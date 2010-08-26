module Caboodle
  module Command
    class << self
      def run(command, args, retries=0)
        case command
        when "create"
        
          puts `mkdir #{args.first}`
          puts `cd #{args.first} && cp -r #{File.expand_path(File.join(File.dirname(__FILE__), 'app'))}/* .`
          puts `cd #{args.first} && cp #{File.expand_path(File.join(File.dirname(__FILE__), 'app'))}/.gems .`
          puts `cd #{args.first} && git init`
          Caboode::Kit.ask_user
          Caboodle::Kit.configure
          puts `cd #{args.first} && git add .`
          puts `cd #{args.first} && git commit -m"initial setup"`
        when /kit:add/
          Caboodle::Kit.load_kit args.first.capitalize
          puts "Dump config"
          Caboodle::Kit.dump_config
          puts "Pushing to Heroku"
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
