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
      
      env['caboodle.config'] ||= Caboodle::Site.clone
      env['caboodle.config'].merge!(Settings)
      
      env['caboodle.config'].each do |k,v|
        self.instance_variable_set("@#{k}".to_sym,v)
      end
    end
    
    error SocketError do
      @title = "Whoops!"
      @message = "Sorry. There was a problem communicating with #{self.class.kit_name}."
      haml File.open(File.join(Caboodle::Kit.root, "views","error.haml")).read
    end
    
    Settings = Hashie::Mash.new
    
    class << self
      
      attr_accessor :credit_link
      
      def inherited subclass
        set :kit_root, File.expand_path(File.dirname(caller[0].split(/:in/).last))
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
      
      def load_custom_config p
        loaded = YAML.load_file(p)
        Hashie::Mash.new(loaded).each{ |k,v| 
          v.strip! if v.class == String
          Settings[k.to_s] = v 
        }
      end
      
      def config_files array_of_files
        configure do
          array_of_files.each do |file|
            config_path = File.expand_path(File.join(Caboodle::App.root,"config",file))
            if File.exists?(config_path)
              load_custom_config(config_path)
            else
              `cp "#{File.join(kit_root,"config",file)}" "#{File.join(Caboodle::App.root,"config",".")}"` rescue "Could not create the config yml file"
              puts "\nThis kit has a separate configuration file which you must edit:\n #{File.expand_path(File.join(Caboodle::App.root,"config",file))}\n"
            end
          end
        end
      end
      
      def files array_of_files
        configure do
          array_of_files.each do |file|
            target_path = File.expand_path(File.join(Caboodle::App.root,"config",file))
            unless File.exists?(target_path)              
              `cp "#{File.join(kit_root,"config",file)}" "#{File.join(Caboodle::App.root,"config",".")}"` rescue "Could not create the config yml file"
            end
          end
        end
      end
      
      def description string
        puts "\n"
        puts "#{name.to_s.split("::").last}: #{string}"
      end
      
      def name
        self.to_s.split("::").last
      end
    
      def menu display, path=nil, &block
        #todo proper slugify
        slug = display.downcase.gsub(" ","-").gsub("'","")
        path = "/#{slug}" unless path
        path = "/" if Site.home_kit == self.to_s.gsub("Caboodle::","")
        Caboodle::MenuItems << {:display=>display, :link=>path, :kit=>self}
        self.before {@title = display}
        if block
          self.get path, &block
        else
          eval "self.get '#{path}' do
          haml :#{slug.gsub("-","_")}
          end"
        end
        @@has_menu = true
      end
      
      def has_menu?
        defined?(@@has_menu)
      end
      
      def required keys
        if keys.class == Array
          keys.each do |k| 
            self.required_settings << k
            puts "self.set #{k}, #{Caboodle::Site[k]}"
            self.set k.to_s.to_sym, Caboodle::Site[k].to_s
          end
        else
          self.required_settings << keys
        end
        self.required_settings
      end
      
      def optional keys
        if keys.class == Array
          keys.each do |k| 
            self.optional_settings << k
            self.set k.to_s.to_sym, Caboodle::Site[k].to_s
          end
        else
          self.optional_settings << keys
        end
        self.optional_settings      
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
      
      def add_layout k, v
        unless Caboodle::Layout[k.to_sym].blank?
          Caboodle::Layout[k.to_sym] << "\n"
          Caboodle::Layout[k.to_sym] << v
        else
          Caboodle::Layout[k.to_sym] = v
        end
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
          add_layout k, v
        end
      end
      
      def defaults hash
        if hash.class == Hash
          hash.each {|k,v| Site[k] = v }
        end
      end
      
      def credit url, title=nil
        #todo there must be an easier way
        class_eval "def credit_link
        \"<a rel='me' href='#{url}'>#{title || self.name.split("::").last}</a>\"
        end"
      end
    
      def required_settings
        RequiredSettings[kit_name] ||= [] 
        RequiredSettings[kit_name]
      end
      
      def optional_settings
        OptionalSettings[kit_name] ||= [] 
        OptionalSettings[kit_name]
      end
      
      def register_kit ask=true
        ask_user_for_missing_settings if ask
        Site.kits << name
        Site.kits.uniq!
        Caboodle::Kits << self
        Caboodle::Kits
      end
      
      def unregister_kit
        Caboodle::Kits.delete(self)
        Caboodle::Site.kits.delete(self.to_s)
        Caboodle::Config.dump_config
        Caboodle::Kits
      end
      
      def ask_user r, optional=false       
        unless ENV["RACK_ENV"] == "production"
          puts " "
          opt = "Optional: " if optional
          puts "#{opt}Please set a value for #{r}:"
          v = STDIN.gets
          Caboodle::Site[r] = v
          Caboodle::Config.dump_config
        end
      end

      def ask_user_for_missing_settings
        required_settings.each do |r|
          if Caboodle::Site[r].blank?
            ask_user r
          end
          puts self
          self.set r.to_s.to_sym, Caboodle::Site[r].to_s
        end
        optional_settings.each do |r|
          unless defined?(Caboodle::Site[r])
            ask_user r, true
          end
          self.set r.to_s.to_sym, Caboodle::Site[r].to_s
        end
      end

      def ask_user_for_all_missing_settings
        Caboodle::Kits.each do |kit|
          kit.ask_user_for_missing_settings
        end
      end
    
      def kit_name
        self.ancestors.first.to_s.split("::").last
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
          STDERR.puts "Warning - #{kit_name} is disabled because:"
          STDERR.puts errors.join("\n") 
          Caboodle::Errors << Hashie::Mash.new(:title=>"#{kit_name} is disable", :reason=>errors.join(";"))
        end
      end

    end
  end
end