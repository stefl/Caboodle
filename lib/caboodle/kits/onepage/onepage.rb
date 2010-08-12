module Caboodle

  class Onepage < Caboodle::Kit
    
    set :views, File.join(File.dirname(__FILE__), "views")
    
    get "/contact" do
      @title = "Contact"
      haml :contact
    end
    
    menu "Contact", "/contact"
    
    required [:onepage_username]
  end
end