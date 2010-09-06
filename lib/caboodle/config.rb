module Caboodle  
  Kits             = []
  MenuItems        = []
  Javascripts      = []
  Stylesheets      = []
  RSS              = []
  SASS             = []
  Errors           = []
  Debug            = []
  Defaults         = Hashie::Mash.new(Hashie::Mash.new(YAML.load_file(File.join(File.dirname(__FILE__), 'config','defaults.yml'))))
  RequiredSettings = Hashie::Mash.new()
  OptionalSettings = Hashie::Mash.new()
  Layout           = Hashie::Mash.new()
  Site             = Defaults.clone
  
  Site.required_settings = []
  Site.kits = [] unless Site.kits
  
  module Config
    class << self
      
      def setup
        require_all
        use_all
      end
 
      def load_config p
        loaded = YAML.load(p)
        Hashie::Mash.new(loaded).each{ |k,v| 
          v.strip! if v.class == String
          Caboodle::Site[k.to_s] = v } rescue puts "Warning! Skipping #{p}"
        Caboodle::Site.kits.uniq!
      end

      def load_config_file p
        configure_site(open(p).read)
      end
    
      def require_all ask=true
        if(Caboodle::Site.kits)
          Caboodle::Site.kits.each { |k| load_kit k, ask }
        else
          STDERR.puts "No kits to register"
        end
        Caboodle::Kits
      end
    
      def use_all
        Caboodle::Kits.each { |p| p.start }
      end
      
      def load_kit name, ask=true
        unless name.blank?
          kit_name = name.to_s.split("::").last || name
          kit_name = kit_name.downcase
          orig = Caboodle.constants
          begin
            puts kit_name
            require "caboodle/kits/#{kit_name}/#{kit_name}"
            added = Caboodle.constants - orig
            added.each do |d| 
              c = Caboodle.const_get(d)
              if c.respond_to?(:is_a_caboodle_kit)
                c.register_kit ask
              end
            end
          rescue Exception=>e
            if ENV["RACK_ENV"] == "production"
              Caboodle::Errors << Hashie::Mash.new({:title=>"Failed to load #{name} kit", :reason=>e.backtrace})
              puts "Failed to load #{name} kit: #{e.backtrace}"
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
          require "caboodle/kits/#{kit_name}/#{kit_name}"
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
      
    end
  end
end