gem "sinatra-compass"
require "sinatra/compass"

gem "compass-susy-plugin"
require "susy"

require "compass"
require "sinatra/base"
require "sinatra/sugar"
require "sinatra/advanced_routes"


module Caboodle
  class History < Caboodle::Kit
      
    config_files ["history.yml"]
    
    configure do
      config_path = File.expand_path(File.join(Caboodle::App.root,"config","history.yml"))
      if File.exists?(config_path)
        Caboodle::Kit.load_config(config_path)
      else
        `cp "#{File.join(File.dirname(__FILE__),"config","history.yml")}" "#{File.join(Caboodle::App.root,"config",".")}"` rescue "Could not create the sample yml file"
        puts "Please enter your history items in the file #{File.expand_path(File.join(Caboodle::App.root,"config","history.yml"))}"
      end
    end
        
    menu "History", "/history" do
      @title = "History"
      haml :history
    end
    
    get("/history/:name.css") do
      content_type 'text/css', :charset => 'utf-8'
      options = {:sass_dir => File.join(File.dirname(__FILE__),"views"), :syntax=>:scss}
      sass :"#{params[:name]}", options.merge!(::Compass.sass_engine_options)
    end
    
    add_sass ["history"]
    
  end
end