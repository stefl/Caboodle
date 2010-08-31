module Caboodle
  class Twitter < Caboodle::Kit
    description "Display recent tweets from a given twitter account, with infinite scrolling for looking back in time."
    menu "Twitter", "/twitter" do
      @title = "Twitter"
      haml :twitter
    end
    
    required [:twitter_username]
    
    credit "http://twitter.com/#{Caboodle::Site.twitter_username}"
    
    add_sass ["twitter"]
  end
end