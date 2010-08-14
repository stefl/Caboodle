module Caboodle
  
  class Kit < Sinatra::Base
    #register Sinatra::Compass
    
    set :app_file, __FILE__
    set :logging, true
    set :root, File.expand_path(File.join(File.dirname(__FILE__),"app"))
    set :public, Proc.new { File.join(root, "public") }
    set :haml, {:format => :html5 }

    helpers Sinatra::CaboodleHelpers

    template :layout do
      @@template ||= File.open(File.join(File.dirname(__FILE__),"app","views","layout.haml")).read
    end
    
    class << self
      
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
        puts "Dump config"
        p = File.expand_path(File.join(Caboodle::App.root,"config","site.yml"))
        d = Caboodle::Site.clone
        e = d.to_hash
        e.delete("required_settings")
        File.open(p, 'w') {|f| f.write(YAML::dump(e))}
      end

      def setup
        require_all
        use_all
      end
      
      def load_kit name
        unless name.blank?
          kit_name = name.to_s.split("::").last || name
          kit_name = kit_name.downcase
          puts "Loading Kit: #{kit_name}"
          orig = Caboodle.constants
          require "caboodle/kits/#{kit_name}/#{kit_name}" rescue puts "Problem loading Kit: #{kit_name}"
          added = Caboodle.constants - orig
          added.each do |d| 
            c = Caboodle.const_get(d)
            if c.respond_to?(:is_a_caboodle_kit)
              c.register 
            end
          end
        end
        Caboodle::Kits
      end
      
      def unload_kit name
        unless name.blank?
          kit_name = name.to_s.split("::").last || name
          kit_name = kit_name.downcase
          puts "Loading Kit: #{kit_name}"
          orig = Caboodle.constants
          require "caboodle/kits/#{kit_name}/#{kit_name}" rescue puts "Problem loading Kit: #{kit_name}"
          added = Caboodle.constants - orig
          added.each do |d| 
            c = Caboodle.const_get(d)
            if c.respond_to?(:is_a_caboodle_kit)
              c.unregister 
            end
          end
        end
        Caboodle::Kits
      end
      
      def register
        required_settings.each do |r|
          unless Caboodle::Site[r]
            puts "Please set a value for #{r}:"
            v = STDIN.gets
            Caboodle::Site[r] = v
            Caboodle::Kit.dump_config
          end
        end
        Site.kits << self.to_s.split("::").last
        Site.kits.uniq!
        Caboodle::Kits << self
      end
      
      def unregister
        Caboodle::Kits.delete(self)
        Caboodle::Site.kits.delete(self.to_s)
        Caboodle::Kit.dump_config
      end      
    
      def require_all
        if(Caboodle::Site.kits)
          Caboodle::Site.kits.each { |k| load_kit k }
        else
          STDERR.puts "Kits not registered"
        end
      end
    
      def use_all
        Caboodle::Kits.each { |p| p.start }
      end
    
      def menu display, link
        Caboodle::MenuItems << {:display=>display, :link=>link}
      end
    
      def required keys
        if keys.class == Array
          keys.each do |k| 
            self.required_settings << k
          end
        else
          self.required_settings << keys
        end
      end
      
      def stylesheets array_of_css_files
        array_of_css_files.each { |a| Caboodle::Stylesheets << a }
        Caboodle::Stylesheets.uniq!
      end
      
      def javascripts array_of_js_files
        array_of_js_files.each { |a| Caboodle::Javascripts << a }
        Caboodle::Javascripts.uniq!
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
    
      def required_settings
        r = RequiredSettings[self.ancestors.first.to_s.split("::").last] ||= [:title, :description, :logo_url, :author] 
        RequiredSettings[self.ancestors.first.to_s.split("::").last]
      end
    
      def start
        errors = []
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
        end
      end
    end
  end
end