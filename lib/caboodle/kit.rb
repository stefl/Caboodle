module Caboodle
  
  class Kit < Sinatra::Base
    
    set :app_file, __FILE__
    set :logging, true
    set :root, File.expand_path(File.join(File.dirname(__FILE__),"app"))
    set :public, Proc.new { File.join(root, "public") }
    set :haml, {:format => :html5 }

    helpers Sinatra::CaboodleHelpers

    template :layout do
      @@template ||= File.open(File.join(File.dirname(__FILE__),"app","views","layout.haml")).read
    end
    
    before do
      Caboodle::Site.cache_for ||= 600
      response.headers['Cache-Control'] = "public, max-age=#{Caboodle::Site.cache_for}"
    end
    
    class << self
      attr_accessor :credit_link
        
      def configure
        config_path = File.expand_path(File.join(Caboodle::App.root,"config","site.yml"))
        if File.exists?(config_path)
          Caboodle::Kit.load_config(config_path)
          Caboodle::Kit.setup
        end
      end
      
      def inherited subclass
        c = caller[0].split(":")
        f = File.dirname(File.expand_path("#{c[0]}"))
        views = File.join(f, "views")
        pub = File.join(f, "public")
        subclass.set :views, views if File.exists?(views)
        subclass.set :public, pub if File.exists?(pub)
        super
      end
      
      def is_a_caboodle_kit
        true
      end
      
      def load_config p
        loaded = YAML.load_file(p)
        Hashie::Mash.new(loaded).each{ |k,v| 
          v.strip! if v.class == String
          Caboodle::Site[k.to_s] = v } rescue puts "Warning! Skipping #{p}"
        Caboodle::Site.kits.uniq!
      end

      def dump_config
        begin
          puts "Dump config"
          p = File.expand_path(File.join(Caboodle::App.root,"config","site.yml"))
          d = Caboodle::Site.clone
          e = d.to_hash
          e.delete("required_settings")
          File.open(p, 'w') {|f| f.write(YAML::dump(e))}
        rescue
          puts "Cannot write config file"
        end
      end

      def setup
        require_all
        use_all
      end
      
      def load_kit name
        unless name.blank?
          kit_name = name.to_s.split("::").last || name
          kit_name = kit_name.downcase
          orig = Caboodle.constants
          begin
            require "caboodle/kits/#{kit_name}/#{kit_name}" #rescue puts "Problem loading Kit: #{kit_name}"
            added = Caboodle.constants - orig
            added.each do |d| 
              c = Caboodle.const_get(d)
              if c.respond_to?(:is_a_caboodle_kit)
                c.register_kit
              end
            end
          rescue Exception=>e
            if ENV["RACK_ENV"] == "production"
              Caboodle::Errors << Hashie::Mash.new({:title=>"Failed to load #{name} kit", :reason=>e.backtrace})
            else
              raise e
            end
          end
        end
        Caboodle::Kits
      end
      
      def unload_kit name
        unless name.blank?
          kit_name = name.to_s.split("::").last || name
          kit_name = kit_name.downcase
          puts "Unloading Kit: #{kit_name}"
          orig = Caboodle.constants
          require "caboodle/kits/#{kit_name}/#{kit_name}" #rescue puts "Problem loading Kit: #{kit_name}"
          added = Caboodle.constants - orig
          added.each do |d| 
            c = Caboodle.const_get(d)
            if c.respond_to?(:is_a_caboodle_kit)
              c.unregister_kit
            end
          end
        end
        Caboodle::Kits
      end
      
      def name
        self.to_s.split("::").last
      end
      
      def register_kit
        required_settings.each do |r|
          puts "checking #{r}"
          puts "value: #{Caboodle::Site[r]}"
          if Caboodle::Site[r].blank?
            puts "Rack env #{ENV["RACK_ENV"]}"
            unless ENV["RACK_ENV"] == "production"
              puts "Please set a value for #{r}:"
              v = STDIN.gets
              Caboodle::Site[r] = v
              Caboodle::Kit.dump_config
            end
          end
        end
        Site.kits << name
        Site.kits.uniq!
        Caboodle::Kits << self
        Caboodle::Kits
      end
      
      def unregister_kit
        Caboodle::Kits.delete(self)
        Caboodle::Site.kits.delete(self.to_s)
        Caboodle::Kit.dump_config
        Caboodle::Kits
      end      
    
      def require_all
        if(Caboodle::Site.kits)
          Caboodle::Site.kits.each { |k| load_kit k }
        else
          STDERR.puts "No kits to register"
        end
        Caboodle::Kits
      end
    
      def use_all
        Caboodle::Kits.each { |p| p.start }
      end
    
      def menu display, path, &block
        path = "/" if Site.home_kit == self.to_s.gsub("Caboodle::","")
        Caboodle::MenuItems << {:display=>display, :link=>path, :kit=>self}
        self.get path, &block
        @@has_menu = true
      end
      
      def has_menu?
        defined?(@@has_menu)
      end
      
      def required keys
        if keys.class == Array
          keys.each do |k| 
            self.required_settings << k
          end
        else
          self.required_settings << keys
        end
        self.required_settings
      end
      
      def stylesheets array_of_css_files
        if array_of_css_files.class == Array
          array_of_css_files.each { |a| Caboodle::Stylesheets << a.to_s }
        else
          Caboodle::Stylesheets << array_of_css_files.to_s
        end
        Caboodle::Stylesheets.uniq!
      end
      
      def add_sass array_of_sass_files
        if array_of_sass_files.class == Array
          array_of_sass_files.each { |a| Caboodle::SASS << a.to_s }
        else
          Caboodle::SASS << array_of_sass_files.to_s
        end
        Caboodle::SASS.uniq!
      end
      
      alias_method :stylesheet, :stylesheets
      
      def javascripts array_of_js_files
        if array_of_js_files.class == Array
          array_of_js_files.each { |a| Caboodle::Javascripts << a.to_s }
        else
          Caboodle::Javascripts << array_of_js_files.to_s
        end
        Caboodle::Javascripts.uniq!
      end
      
      alias_method :javascript, :javascripts
      
      def rss array_of_feeds
        if array_of_feeds.class == Array
          array_of_feeds.each { |a| Caboodle::RSS << a.to_s }
        else
          Caboodle::RSS << array_of_feeds.to_s
        end
        Caboodle::RSS.uniq!
      end
      
      def add_to_layout hash_of_items
        hash_of_items.each do |k,v|
          unless Caboodle::Layout[k.to_sym].blank?
            Caboodle::Layout[k.to_sym] << "\n"
            Caboodle::Layout[k.to_sym] << v
          else
            Caboodle::Layout[k.to_sym] = v
          end
        end
        puts Caboodle::Layout.inspect
      end
      
      def defaults hash
        if hash.class == Hash
          hash.each {|k,v| Site[k] = v }
        end
      end
      
      def credit url
        #todo there must be an easier way
        class_eval "def credit_link
        \"<a rel='me' href='#{url}' rel='me'>#{self.name.split("::").last}</a>\"
        end"
      end
    
      def required_settings
        r = RequiredSettings[self.ancestors.first.to_s.split("::").last] ||= [] 
        RequiredSettings[self.ancestors.first.to_s.split("::").last]
      end
    
      def available_kits
        Dir.new(File.join(File.dirname(__FILE__),"kits")).entries.delete_if{|a| a[0,1]=="."}
      end
      
      def start
        errors = []
        puts self.required_settings.inspect
        self.required_settings.each do |s|
          if Site[s].blank?
            errors << "    :#{s} has not been set"
          end
        end
      
        if errors.empty?
          Caboodle::App.use self 
        else
          STDERR.puts " "
          STDERR.puts "Warning - #{self.ancestors.first} is disabled because:"
          STDERR.puts errors.join("\n") 
          Caboodle::Errors << Hashie::Mash.new(:title=>"#{self.ancestors.first} is disable", :reason=>errors.join(";"))
        end
      end
    end
  end
end