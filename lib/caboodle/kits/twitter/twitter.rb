module Caboodle
  class Twitter < Caboodle::Kit
    
    menu "Twitter", "/twitter" do
      @title = "Twitter"
      haml :twitter
    end
    
    required [:twitter_username]
    
    original "http://twitter.com/#{Caboodle::Site.twitter_username}"
  end
end