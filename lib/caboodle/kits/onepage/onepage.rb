module Caboodle
  class Onepage < Caboodle::Kit
        
    description "Embeds a Onepage.com contact card and loads it at /contact"
    
    menu "Contact"
    
    required [:onepage_username]
    
    credit "http://myonepage.com/#{onepage_username}"
  end
end