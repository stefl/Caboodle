module Caboodle
  class Carbonmade < Caboodle::Kit
    description "Embeds a Carbonmade.com portfolio."
    
    menu "Portfolio"
    
    required [:carbonmade_url]
    
    credit carbonmade_url, "Carbonmade portfolio"
    
    add_sass ["carbonmade"]
  end
end