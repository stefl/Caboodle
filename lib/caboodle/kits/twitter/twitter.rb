class Caboodle::Twitter < Caboodle::Kit
  description "Display recent tweets from a given twitter account, with infinite scrolling for looking back in time."
  
  menu "Twitter"
  
  required [:twitter_username]
  
  credit "http://twitter.com/#{twitter_username}", "Follow @#{twitter_username} on Twitter"
  
  add_sass ["twitter"]
end