
class Caboodle::Lastfm < Caboodle::Kit
  description "Displays your recent and all time top Last.fm plays"
  
  required [:lastfm_username]
  
  def scrape 
    @last ||= Caboodle.scrape("http://www.last.fm/user/#{lastfm_username}")
  end
  
  menu "Listening" do

    @recent = scrape.css("#recentTracks .module-body").to_html
    @recent.gsub!("href=\"/", 'href="http://last.fm/')
    @top = scrape.css(".modulechartsartists .module-body").to_html
    @top.gsub!("href=\"/", 'href="http://last.fm/')
    
    haml :listening
  end
  
  credit "http://www.last.fm/listen/user/#{lastfm_username}", "#{lastfm_username} on Last.fm"
  
end