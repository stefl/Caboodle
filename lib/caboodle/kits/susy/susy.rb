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
    description "Adds Susy CSS formatting"     
    get("/susy/:name.css") do
      content_type 'text/css', :charset => 'utf-8'
      sass_dir = File.expand_path(File.join(File.dirname(__FILE__),"views","susy"))
      load_paths = [App.root, File.join(App.root,"views"), File.join(App.root,"views","stylesheets"), sass_dir] + ::Compass.sass_engine_options[:load_paths]
      Kits.each do |name|
        kit_name = name.to_s.split("::").last || name
        kit_name = kit_name.downcase
        path = File.expand_path(File.join(File.dirname(__FILE__),"..",kit_name,"views"))
        load_paths << path
      end
      
      options = {:sass_dir => sass_dir, :syntax => :scss, :load_paths => load_paths}
      the_sass = open(File.join(File.dirname(__FILE__),"views","susy","screen.scss")).read
      imported_files = []
      SASS.each do |s|
        the_sass << "\n"
        add_file = "@import \"#{s}\";"
        imported_files << add_file
        the_sass << add_file
      end
      
      the_sass << "\n/* Generated from:"
      the_sass << load_paths.join("\n")
      the_sass << "\n"
      the_sass << imported_files.join("\n")
      the_sass << "*/"
      
      opts = options.merge!(::Compass.sass_engine_options)
      opts[:load_paths] = load_paths
      sass the_sass, opts
    end

    stylesheets ["/susy/screen.css"]

  end
end
