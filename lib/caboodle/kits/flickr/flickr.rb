require "open-uri"
require "nokogiri"

module Caboodle
  
  class FlickrAPI < Weary::Base
  
    def self.flickr_user_id
      return Site.flickr_user_id unless Site.flickr_user_id.blank?
      unless Site.flickr_username.blank?
        url = "http://query.yahooapis.com/v1/public/yql?q=use%20%22http%3A%2F%2Fisithackday.com%2Fapi%2Fflickr.whois.xml%22%20as%20flickr.whois%3Bselect%20*%20from%20flickr.whois%20where%20owner%3D%22#{Site.flickr_username}%22&format=xml"
        doc = ::Nokogiri::XML.parse(open(url).read)
        val = doc.css("owner").first.attributes["nsid"].value
        Site.flickr_user_id = val
        Caboodle::Kit.dump_config
      end
      Site.flickr_user_id
    end
    
    def initialize(opts={})
      self.defaults = {:api_key => Site.flickr_api_key}
    end
  
    declare "photosets" do |r|
      r.url = "http://api.flickr.com/services/rest/?method=flickr.photosets.getList&api_key=#{Site.flickr_api_key}&user_id=#{FlickrAPI.flickr_user_id}"
      r.via = :get
    end
    
    declare "photoset" do |r|
      r.url = "http://api.flickr.com/services/rest/"
      r.with = [:api_key, :photoset_id]
      r.requires = [:api_key, :photoset_id,:method]
      r.via = :get
    end
    
    def self.photoset_info(id)
      Caboodle.mash(new.photoset({:photoset_id=>id,:method=>"flickr.photosets.getInfo"})).rsp.photoset
    end
    
    def self.photoset_photos(id)
      Caboodle.mash(new.photoset({:photoset_id=>id,:method=>"flickr.photosets.getPhotos"})).rsp.photoset.photo
    end
    
    def self.photosets
      Caboodle.mash(new.photosets).rsp.photosets.photoset
    end

  end

  class Flickr < Caboodle::Kit
    
    description "A browsable Flickr.com gallery with sets"
    
    required [:flickr_username, :flickr_api_key]
    
    menu "Photography" do
      @photosets = FlickrAPI.photosets rescue []
      haml :photography
    end
    
    get "/photography/:set_id" do |set_id|
      @photosets = FlickrAPI.photosets rescue []
      @set_id = set_id
      @photoset = FlickrAPI.photoset_info(@set_id) rescue nil
      @title = "Photography: #{@photoset.title if @photoset.respond_to?(:title)}"
      haml :photography
    end
    
    javascripts ["/galleria.noconflict.min.js"]
    
    add_sass ["photography"]
    
    credit "http://flickr.com/#{flickr_username}", "#{flickr_username} on Flickr.com"
  end
end