module Caboodle
  class Onepage < Caboodle::Kit
        
    menu "Contact", "/contact" do
      @title = "Contact"
      haml :contact
    end
    
    required [:onepage_username]
    
    credit "http://myonepage.com/#{Caboodle::Site.onepage_username}"
  end
end