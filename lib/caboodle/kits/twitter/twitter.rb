module Caboodle
  class Twitter < Caboodle::Kit
    
    get "/twitter" do
      @title = "Twitter"
      haml :twitter
    end
    
    menu "Twitter", "/twitter"
    
    required [:twitter_username]
  end
end