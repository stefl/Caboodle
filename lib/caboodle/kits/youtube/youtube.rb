require 'youtube_g'

module Caboodle
  class Youtube < Caboodle::Kit
    description "Display's a user's public videos as a page"
    
    required [:youtube_username]
    
    menu "Youtube" do
      client = YouTubeG::Client.new
      @videos = client.videos_by(:user => @youtube_username).videos
      haml :youtube
    end
    
  end
end