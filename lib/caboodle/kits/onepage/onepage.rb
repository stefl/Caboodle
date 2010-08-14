module Caboodle
  class Onepage < Caboodle::Kit
        
    get "/contact" do
      @title = "Contact"
      haml :contact
    end
    
    menu "Contact", "/contact"
    
    required [:onepage_username]
  end
end