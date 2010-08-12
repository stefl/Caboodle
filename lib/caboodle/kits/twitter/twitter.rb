module Caboodle
  class Twitter < Caboodle::Kit
    
    set :views, File.join(File.dirname(__FILE__), "views")
    set :public, File.join(File.dirname(__FILE__), "public")
    
    get "/twitter" do
      @title = "Twitter"
      haml :twitter
    end
    
    menu "Twitter", "/twitter"
    
    required [:twitter_username]
  end
end