gem "sinatra-compass"
require "sinatra/compass"

gem "compass-susy-plugin"
require "susy"

require "compass"
require "sinatra/base"
require "sinatra/sugar"
require "sinatra/advanced_routes"

module Caboodle
  class Susy < Caboodle::Kit
            
    get("/susy/:name.css") do
      content_type 'text/css', :charset => 'utf-8'
      options = {:sass_dir => File.join(File.dirname(__FILE__),"views","susy"), :syntax=>:scss}
      sass :"susy/#{params[:name]}", options.merge!(::Compass.sass_engine_options)
    end

    stylesheets ["/susy/screen.css"]

  end
end
