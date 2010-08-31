module Caboodle
  class Googlelocal < Caboodle::Kit
    
    description "A google map linking to a list of locations and enabling Local Search around each of them."
    
    required [:google_maps_api_key]
    
    config_files ["googlelocal.yml"]
    
    stylesheets ["http://www.google.com/uds/solutions/mapsearch/gsmapsearch.css", "http://www.google.com/uds/css/gsearch.css"]
    
    before do
      @locations = Config.google_local_locations
    end
    
    menu "Near me", "/near_me" do
      @title = "Near me"
      @location = Config.google_local_locations.first
      haml :googlelocal
    end
    
    get "/near_me/:slug" do
      Config.google_local_locations.each do |loc|
        if loc.title.downcase.gsub(" ","-") == params[:slug]
          @location = loc
        end
      end
      
      puts @location.inspect
      
      if @location
        haml :googlelocal
      else
        redirect "/near_me" 
      end
    end
    
    add_sass ["googlelocal"]
  end
end