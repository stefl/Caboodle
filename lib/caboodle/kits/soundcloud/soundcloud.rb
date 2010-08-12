module Caboodle
  class Soundcloud < Caboodle::Kit
    
    set :views, File.join(File.dirname(__FILE__), "views")
    set :public, File.join(File.dirname(__FILE__), "public")
    
    get "/mixes" do
      @title = "Mixes"
      @mixes = SoundcloudAPI.sets
      haml :soundcloud
    end
    
    menu "Mixes", "/mixes"
    
    required [:soundcloud_query]
  end

  class SoundcloudAPI < Weary::Base
    
      declare "sets" do |r|
        r.url = "http://api.soundcloud.com/playlists?q=#{Site.soundcloud_query}"
        r.via = :get
        r.headers = {'Accept' => 'application/xml'}
      end
      
      def self.sets
        Hashie::Mash.new(SoundcloudAPI.new.sets.perform_sleepily.parse).playlists
      end

  end
end