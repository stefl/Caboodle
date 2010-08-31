module Caboodle
  class Disqus < Caboodle::Kit
    
    description "Adds a chat page and support for other kits that require comments"    
    
    menu "Chat", "/chat" do
      @title = "Chat"
      haml :disqus
    end
    
    required [:disqus]
  end
end