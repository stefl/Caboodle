$: << File.expand_path(File.dirname(__FILE__))

require 'weary'
require 'nokogiri'

module Caboodle
  class PosterousAPI < Weary::Base
  
    def initialize(opts={})
      Caboodle::Site.posterous_password ||= ENV["posterous_password"]
      self.credentials(opts[:username] || Caboodle::Site.posterous_username, opts[:password] || Caboodle::Site.posterous_password)
      sitename = opts[:sitename] || Caboodle::Site.posterous_sitename
      unless defined?(Caboodle::Site.posterous_site_id)
        sites = Hashie::Mash.new(getsites.perform_sleepily.parse).rsp.site
      
        sites.each do |site|
          if site.url.include?("http://#{Caboodle::Site.posterous_sitename}.posterous.com")
            puts "GOT SITE ID: #{site.id}"
            Caboodle::Site.posterous_site_id = site.id
          end
        end
      end
      
      self.defaults = {:site_id => Caboodle::Site.posterous_site_id}
    end
  
    declare "getsites" do |r|
      r.url = "http://posterous.com/api/getsites"
      r.via = :get
      r.authenticates = true
      r.headers = {'Accept' => 'application/xml'}
    end
    
    declare "all" do |r|
      r.url = "http://posterous.com/api/readposts"
      r.via = :get
      r.with = [:site_id,:tag,:num_posts,:page]
      r.requires = [:site_id]
      r.authenticates = true
      r.headers = {'Accept' => 'application/xml'}
    end
    
  end

  class Post
  
    attr_accessor :attributes
  
    def initialize(res)
      @attributes = res
    end
  
    def self.from_slug(slug)
      doc = Caboodle.scrape("http://#{Caboodle::Site.posterous_sitename}.posterous.com/#{slug}")
      opts = {}
      opts["body"] = doc.css('div.bodytext').inner_html
      opts["title"] = doc.css('title').inner_html.split(" - ").first
      opts["link"] = "http://#{Caboodle::Site.posterous_sitename}.posterous.com/#{slug}"
      perma = doc.css('.permalink').inner_html
      STDERR.puts "Opts: #{opts.inspect}"
      STDERR.puts "Perma: #{perma}"
      opts["date"] = Date.parse(perma)
      Post.new(opts)
    end
  
    def self.page(num)
      raise "must be page 1 or more" if num.to_i < 1
      Post.all(:page=>num.to_i)
    end
  
    def self.all(opts={})
      r = []
      STDERR.puts "All posts for: #{opts.inspect}"
      p = PosterousAPI.new
      opts[:site_id] = Caboodle::Site.posterous_site_id 
      rsp = p.all(opts).perform_sleepily.parse["rsp"]
      rsp["post"].each{|a| r << Post.new(a)} if rsp["post"]
      r
    end
  
    def self.get(slug)
      Post.new(PosterousAPI.new.all().perform.parse)
    end
  
    def [] k
      @attributes[k]
    end
  
    def []= l,v
      @attributes = {} if @attributes.nil?
      @attributes[l] = v
    end
  
    def method_missing arg
      self[arg.to_s]
    end
  
    def tags
      []
    end
  
    def semantic_tags
      a = tags.collect{|t| "tag-#{t}"}
      a << "slug-#{slug}"
      a << "y#{date.year}"
      a << "m#{date.month}"
      a << "d#{date.day}"
    end
  
    def url
  		d = date
  		"/#{d.year}/#{d.month}/#{slug}"
  	end
	
  	def date
  	  return @date if defined?(@date) 
  	  if attributes["date"].class == String
  	    @date = Date.parse(attributes["date"])
  	  else
  	    @date = attributes["date"]
  	  end
    end

  	def full_url
  		Caboodle::Site.url_base.gsub(/\/$/, '') + url
  	end
  
    def slug
      self.link.split(".posterous.com/").last.split("/").last
    end
  end

  class Posterous < Caboodle::Kit
  
    get "/page/:page_number" do |page_number|
      @posts = Post.page(page_number) rescue nil
      not_found if @posts.class == Array && @posts.blank?
      haml :posts
    end

    get "/:year/:month/:slug" do |year, month, slug|
      STDERR.puts "Get a post"
    	post = Post.from_slug(slug) rescue nil
    	STDERR.puts "Slug not found: #{slug}"
    	not_found unless post
    	@title = post.title
    	haml :post, :locals => { :post => post }
    end
    
    menu "Blog", "/blog" do
      @posts = Post.all(:page=>(params[:page] || 1))
      haml :posts.to_sym
    end
    
    required [:posterous_sitename, :posterous_username, :posterous_password, :disqus]
      
    stylesheets ["http://disqus.com/stylesheets/#{Caboodle::Site.disqus}/disqus.css?v=2.0"]
     
    rss ["feed://stef.posterous.com/rss.xml"]
    
    original "http://#{Caboodle::Site.posterous_sitename}.posterous.com"
  end
end

#Caboodle::Posterous.new #gets the ID set up