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
          Caboodle::Kit.configure
          puts `cd #{args.first} && git add .`
          puts `cd #{args.first} && git commit -m"initial setup"`
          puts `cd #{args.first} && heroku create #{args.first}`
          
        when /kit:add/
          Caboodle::Kit.load_kit args.first.capitalize
          puts "Dump config"
          Caboodle::Kit.dump_config
          puts "Pushing to Heroku"
          puts `git add .`
          puts `git commit -m"kit:add #{args}" -a`
          puts `git push heroku master`
          puts "Done!"
        when /kit:remove/
          Caboodle::Kit.unload_kit args.first.capitalize
          puts "Pushing to Heroku"
          puts `git add .`
          puts `git commit -m"kit:remove #{args}" -a`
          puts `git push heroku master`
          puts "Done!"
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