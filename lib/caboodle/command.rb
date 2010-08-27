
module Caboodle
  module Command
    class << self
      def configure
        config = File.expand_path(File.join(".","config","site.yml"))
        Caboodle::Kit.configure_site config
      end
      
      def run(command, args, retries=0)
        case command
        when "create"
          puts "Welcome to Caboodle!"
          site_name = args.first
          puts `mkdir -p #{site_name}`
          puts `cd #{site_name} && cp -ri #{File.expand_path(File.join(File.dirname(__FILE__), 'app'))}/* .`
          puts `cd #{site_name} && cp -i #{File.expand_path(File.join(File.dirname(__FILE__), 'app'))}/.gems .`
          puts `cd #{site_name} && git init`
          config = File.expand_path(File.join(".",site_name,"config","site.yml"))
          Caboodle::Kit.configure_site config
          puts "Please set a few settings to get started"
          Caboodle::Kit.ask_user_for_all_missing_settings
          puts `cd #{site_name} && git add .`
          puts `cd #{site_name} && git commit -m"initial setup"`
        when /kit:add/
          Caboodle::Kit.load_kit args.first.capitalize
          puts "Dump config"
          Caboodle::Kit.dump_config
          puts "Pushing to Heroku"
          puts "Please be patient - this could take some time the first time you do this"
          puts `git add .`
          puts `git commit -m"kit:add #{args}" -a`
          puts `git push heroku master`
          puts "Done!"
        when /kit:home/
          if Caboodle::Kit.available_kits.include?(args.first.capitalize)
            Caboodle::Site.home_kit = args.first.capitalize
          else
            puts "Sorry - that Kit isn't available. Try:"
            Caboodle::Kit.available_kits.each {|kit| puts kit}
          end
        when /kit:list/
          Caboodle::Kit.available_kits.each {|kit| puts kit}
        when /kit:remove/
          Caboodle::Kit.unload_kit args.first.capitalize
          puts "Pushing to Heroku"
          puts `git add .`
          puts `git commit -m"kit:remove #{args}" -a`
          puts `git push heroku master`
          puts "Done!"
        when /config:list/
          configure
          Caboodle::Site.each{|k,v| puts "#{k}: #{v}"}
        when /config:set/
          configure
          Caboodle::Site[args[0]] = args[1]
          Caboodle::Kit.dump_config
        when /config:get/
          configure
          puts Caboodle::Site[args[0]]
        when "deploy"
          gem 'heroku'
          require 'heroku'
          require 'heroku/command'
        
          puts `git commit -m"deploy" -a`
          puts `git push heroku master`
        else
          puts "Sorry, that command is not recognized"
        end
      end
    end
  end
end
