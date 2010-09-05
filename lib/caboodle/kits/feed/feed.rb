require 'feed-normalizer'
require 'open-uri'
    
module Caboodle
  class Feed < Caboodle::Kit
    description "Displays multiple RSS/Atom feeds as sections of the site with menu items"
    
    config_files ["feed.yml"]
    
    add_sass ["feed"]
    
    configure do
      puts "Configure it"
      puts Settings.feeds.inspect
      Settings.feeds.each do |feed_name,feed_url|
        menu feed_name do
          @feed = FeedNormalizer::FeedNormalizer.parse open(feed_url)
          @feed.clean!
          haml :feed
        end
      end
    end
  end
end