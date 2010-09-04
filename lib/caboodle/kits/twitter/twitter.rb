require 'nokogiri'
require 'open-uri'

module Caboodle
  class Twitter < Caboodle::Kit
    description "Display recent tweets from a given twitter account, with infinite scrolling for looking back in time."
  
    required [:twitter_username]
  
    menu "Twitter"
  
    configure do
      if Site.logo_url.to_s.blank? && !Site.twitter_username.to_s.blank?
        xml = Nokogiri::XML(open("http://twitter.com/users/#{Site.twitter_username}.xml").read)
        Site.logo_url = xml.css("profile_image_url").children.first.to_s 
      end
    end
  
    credit "http://twitter.com/#{twitter_username}", "Follow @#{twitter_username} on Twitter"
  
    add_sass ["twitter"]
  end
end