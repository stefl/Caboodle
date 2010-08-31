module Caboodle
  class Googlelocal < Caboodle::Kit
    
    description "A google map linking to a list of locations and enabling Local Search around each of them."
    
    required [:google_maps_api_key]
    
    config_files ["googlelocal.yml"]
    
    stylesheets ["http://www.google.com/uds/solutions/mapsearch/gsmapsearch.css", "http://www.google.com/uds/css/gsearch.css"]
    
    menu "Near me", "/near_me" do
      @title = "Near me"
      @locations = Config.google_local_locations
      puts @locations.inspect
      haml :googlelocal
    end
    
    add_sass ["googlelocal"]
  end
end