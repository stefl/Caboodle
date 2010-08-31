module Caboodle
  class Soundcloud < Caboodle::Kit
    description "Displays a search of soundcloud as embedded players on a single page."
    menu "Mixes", "/mixes" do
      @title = "Mixes"
      @mixes = SoundcloudAPI.sets
      haml :soundcloud
    end

    required [:soundcloud_query]
    
    credit "http://soundcloud.com"
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