gem 'heroku'
require 'heroku'
require 'heroku/command'

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
          puts `cd #{args.first} && git add .`
          puts `cd #{args.first} && git commit -m"initial setup"`
          puts `cd #{args.first} && heroku create #{args.first}`
          puts `cd #{args.first} && git push heroku master`
          
        when /kit:add/
          unless Caboodle::Site.kits.include?(args.first.capitalize)
            Caboodle::Kit.load_kit args.first.capitalize
            Caboodle::Kit.dump_config
            puts `git add .`
            puts `git commit -m"kit:add #{args}" -a`
            puts `git push heroku master`
          end
        when "deploy"
          puts `git commit -m"deploy" -a`
          puts `git push heroku master`
        else
          Heroku::Command.run(command,args,retries)
        end
      end
    end
  end
end