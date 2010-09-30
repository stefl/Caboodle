
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
          puts `cd #{site_name} && cp -i #{File.expand_path(File.join(File.dirname(__FILE__), 'app'))}/config.ru .`
          puts `cd #{site_name} && cp -ri #{File.expand_path(File.join(File.dirname(__FILE__), 'app'))}/config .`
          puts `cd #{site_name} && cp -i #{File.expand_path(File.join(File.dirname(__FILE__), 'app'))}/.gems .`
          puts `cd #{site_name} && cp -ri #{File.expand_path(File.join(File.dirname(__FILE__), 'app'))}/public .`
          puts `cd #{site_name} && cp -ri #{File.expand_path(File.join(File.dirname(__FILE__), 'app'))}/pages .`
          puts `cd #{site_name} && cp -ri #{File.expand_path(File.join(File.dirname(__FILE__), 'app'))}/scss .`
          puts `cd #{site_name} && git init`
          config = File.expand_path(File.join(".",site_name,"config","site.yml"))
          Caboodle::Kit.configure_site config
          puts "Please set a few settings to get started"
          Caboodle::Kit.ask_user_for_all_missing_settings
          puts `cd #{site_name} && git add .`
          puts `cd #{site_name} && git commit -m"initial setup"`
        when /kit:add/
          Caboodle::Config.load_kit args.first.capitalize
          Caboodle::Kit.dump_config
          puts `git commit -m"kit:add #{args}" -a`
        when /kit:home/
          Caboodle::Site.home_kit = args.first.capitalize
          Caboodle::Kit.dump_config
        when /kit:list/
          Caboodle::Kit.available_kits.each {|kit| puts kit}
        when /kit:remove/
          Caboodle::Config.unload_kit args.first.capitalize
          Caboodle::Kit.dump_config
          puts `git commit -m"kit:remove #{args}" -a`
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
        when /config:kits/
          puts "The following kits are loaded"
          configure
          puts Caboodle::Site.kits.join("\n")
        when "heroku:create"
          gem 'heroku'
          require 'heroku'
          require 'heroku/command'
          `heroku create #{args[0]}`
        when "heroku:deploy"
          gem 'heroku'
          require 'heroku'
          require 'heroku/command'
        
          puts `git commit -m"heroku:deploy" -a`
          puts `git push heroku master`
        else
          puts "Sorry, that command is not recognized" unless command == "help"
          puts "Caboodle accepts the following commands:"
          puts " "
          puts "caboodle create <sitename> - sets up a new caboodle"
          puts "caboodle kit:add <kit name> - adds a specificed kit to the caboodle"
          puts "caboodle kit:home <kit name> - sets the kit as the one that runs the home page"
          puts "caboodle kit:remove <kit name> - removes the kit"
          puts "caboodle kit:list - lists all of the available kits"
          puts "caboodle config:list - shows the configuration variables"
          puts "caboodle config:set <variable name> <value> - sets a value for the configuration variable"
          puts "caboodle config:get <variable name> - shows the value of the configuration variable"
          puts "caboodle heroku:create - sets up a new Heroku instance"
          puts "caboodle heroku:deploy - pushes the caboodle to Heroku"
        end
      end
    end
  end
end
