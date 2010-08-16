module Caboodle
  class Disqus < Caboodle::Kit
        
    menu "Chat", "/chat" do
      @title = "Chat"
      haml :disqus
    end
    
    required [:disqus]
  end
end