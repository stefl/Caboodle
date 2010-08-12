module Caboodle
  Kits = []
  Javascripts = []
  Stylesheets = []
  
  class Kit < Sinatra::Base
    #register Sinatra::Compass
    
    set :app_file, __FILE__
    set :logging, true
    set :root, File.expand_path(File.join(File.dirname(__FILE__),"app"))
    set :public, Proc.new { File.join(root, "public") }
    set :haml, {:format => :html5 }

    template :layout do
      @@template ||= File.open(File.join(File.dirname(__FILE__),"app","views","layout.haml")).read
      puts @@template.inspect
      @@template
    end
    
    class << self
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
        p = File.expand_path(File.join(Caboodle::App.root,"site.yml"))
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
          puts "Load kit #{name}"
          kit_name = name.to_s.split("::").last || name
          kit_name = kit_name.downcase
          orig = Caboodle.constants
          require "caboodle/kits/#{kit_name}/#{kit_name}" rescue puts "No such kit: #{kit_name}"
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
      
      def register
        required_settings.each do |r|
          unless Caboodle::Site[r]
            puts "Please set a value for #{r}:"
            v = STDIN.gets
            Caboodle::Site[r] = v
            Caboodle::Kit.dump_config
          end
        end
        Caboodle::Kits << self
      end
    
      def require_all
        if(Caboodle::Site.kits)
          Caboodle::Site.kits.each do |k|
            puts "Load Kit: #{k}"
            load_kit k
          end
        else
          puts "Kits not registered"
        end
      end
    
      def use_all
        Caboodle::Kits.each do |p|
          p.start
        end
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
        array_of_css_files.each do |a|
          Caboodle::Stylesheets << a
        end
        Caboodle::Stylesheets.uniq!
      end
      
      def javascripts array_of_js_files
        array_of_js_files.each do |a|
          Caboodle::Javascripts << a
        end
        Caboodle::Javascripts.uniq!
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