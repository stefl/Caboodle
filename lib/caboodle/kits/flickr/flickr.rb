module Caboodle
  
  class FlickrAPI < Weary::Base
  
    def initialize(opts={})
      self.defaults = {:api_key => Site.flickr_api_key}
    end
  
    declare "photosets" do |r|
      r.url = "http://api.flickr.com/services/rest/?method=flickr.photosets.getList&api_key=#{Site.flickr_api_key}&user_id=#{Site.flickr_user_id}"
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
    
    set :views, File.join(File.dirname(__FILE__), "views")
    set :public, File.join(File.dirname(__FILE__), "public")
    
    def home
      @photosets = FlickrAPI.photosets rescue []
      @title = "Photography"
      haml :photography
    end
    
    get "/photography" do
      home
    end
    
    get "/photography/:set_id" do |set_id|
      @photosets = FlickrAPI.photosets rescue []
      @set_id = set_id
      @photoset = Caboodle::FlickrAPI.photoset_info(@set_id) rescue nil
      @title = "Photography: #{@photoset.title if @photoset.respond_to?(:title)}"
      haml :photography
    end
    
    required [:flickr_username, :flickr_user_id, :flickr_api_key]
    
    menu "Photography", "/photography"
  end
end