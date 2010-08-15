module Caboodle
  class Onepage < Caboodle::Kit
        
    menu "Contact", "/contact" do
      @title = "Contact"
      haml :contact
    end
    
    required [:onepage_username]
    
    original "http://myonepage.com/#{Caboodle::Site.onepage_username}"
  end
end