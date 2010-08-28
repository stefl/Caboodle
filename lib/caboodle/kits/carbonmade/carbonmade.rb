module Caboodle
  class Carbonmade < Caboodle::Kit
        
    menu "Portfolio", "/portfolio" do
      @title = "Portfolio"
      haml :carbonmade
    end
    
    required [:carbonmade_url]
    
    credit Caboodle::Site.carbonmade_url
    
    add_sass ["carbonmade"]
  end
end