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
      
    description "A list of things you have done in the past."
    
    config_files ["history.yml"]
        
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