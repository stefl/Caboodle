module Caboodle
  class Onepage < Caboodle::Kit
        
    description "Embeds a Onepage.com contact card and loads it at /contact"
    
    menu "Contact", "/contact" do
      @title = "Contact"
      haml :contact
    end
    
    required [:onepage_username]
    
    credit "http://myonepage.com/#{Caboodle::Site.onepage_username}"
  end
end