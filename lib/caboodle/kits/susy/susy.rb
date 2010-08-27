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
      sass_dir = File.expand_path(File.join(File.dirname(__FILE__),"views","susy"))
      load_paths = [Caboodle::App.root, File.join(Caboodle::App.root,"views"), File.join(Caboodle::App.root,"views","stylesheets"), sass_dir] + ::Compass.sass_engine_options[:load_paths]
      Caboodle::Kits.each do |name|
        kit_name = name.to_s.split("::").last || name
        kit_name = kit_name.downcase
        load_paths << File.expand_path(File.join(File.dirname(__FILE__),"..",kit_name,"views"))
      end
      
      options = {:sass_dir => sass_dir, :syntax => :scss, :load_paths => load_paths}
      the_sass = open(File.join(File.dirname(__FILE__),"views","susy","screen.scss")).read
      Caboodle::SASS.each do |s|
        the_sass << "\n"
        add_file = "@import \"#{s}\";"
        the_sass << add_file
      end
      
      opts = options.merge!(::Compass.sass_engine_options)
      opts[:load_paths] = load_paths
      sass the_sass, opts
    end

    stylesheets ["/susy/screen.css"]

  end
end
