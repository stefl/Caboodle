$: << File.expand_path(File.dirname(__FILE__))

require 'weary'
require 'nokogiri'

module Caboodle
  class PosterousAPI < Weary::Base
  
    def initialize(opts={})
      Site.posterous_password ||= ENV["posterous_password"]
      
      u = opts[:email] || Site.posterous_email
      p = opts[:password] || Site.posterous_password
      
      self.credentials(u, p)
      sitename = opts[:sitename] || Site.posterous_sitename
      unless defined?(Site.posterous_site_id)
        response = Hashie::Mash.new(getsites.perform_sleepily.parse)
        sites = response.rsp.site        
        sites.each do |site|
          if site.url.include?("http://#{Site.posterous_sitename}.posterous.com")
            Site.posterous_site_id = site.id
          end
        end
      end
      
      self.defaults = {:site_id => Site.posterous_site_id}
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

  class PosterousPost
  
    attr_accessor :attributes
  
    def initialize(res)
      @attributes = res
    end
  
    def self.from_slug(slug)
      doc = Caboodle.scrape("http://#{Site.posterous_sitename}.posterous.com/#{slug}")
      opts = {}
      opts["body"] = doc.css('div.bodytext').inner_html
      opts["title"] = doc.css('title').inner_html.split(" - ").first
      opts["link"] = "http://#{Site.posterous_sitename}.posterous.com/#{slug}"
      perma = doc.css('.permalink').inner_html
      date = doc.css('article time').first["datetime"]
      puts date
      opts["date"] = Date.parse(date)
      PosterousPost.new(opts)
    end
  
    def self.page(num)
      raise "must be page 1 or more" if num.to_i < 1
      PosterousPost.all(:page=>num.to_i)
    end
  
    def self.all(opts={})
      r = []
      p = PosterousAPI.new
      opts[:site_id] = Site.posterous_site_id 
      rsp = p.all(opts).perform_sleepily.parse["rsp"]
      posts = rsp["post"]
      posts = [posts] if posts.class == Hash
      posts.each{|a| r << PosterousPost.new(a) } if posts
      r
    end
  
    def self.get(slug)
      PosterousPost.new(PosterousAPI.new.all().perform.parse)
    end
  
    def [] k
      @attributes = {} if @attributes.nil?
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
      a
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
  		Site.url_base.gsub(/\/$/, '') + url
  	end
  
    def slug
      self.link.split(".posterous.com/").last.split("/").last
    end
  end
  
  class Posterous < Caboodle::Kit
  
    description "Displays a Posterous blog with permalinks, pagination and commends if the Disqus kit is included"
    
    required [:posterous_sitename, :posterous_email, :posterous_password]
    
    optional [:disqus]
    
    get "/posterous/:page_number" do |page_number|
      @posts = PosterousPost.page(page_number)
      not_found if @posts.class == Array && @posts.blank?
      haml :posts
    end

    get "/:year/:month/:slug" do |year, month, slug|
      STDERR.puts "Get a post"
    	post = PosterousPost.from_slug(slug)
    	STDERR.puts "Slug not found: #{slug}"
    	not_found unless post
    	@title = post.title
    	haml :post, :locals => { :post => post }
    end
    
    menu "Blog", "/posterous" do
      @posts = PosterousPost.all(:page=>(params[:page] || 1))
      haml :posts.to_sym
    end

    stylesheets ["http://disqus.com/stylesheets/#{disqus}/disqus.css?v=2.0"] if disqus
     
    rss ["feed://#{posterous_sitename}.posterous.com/rss.xml"]
    
    credit "http://#{posterous_sitename}.posterous.com", "#{posterous_sitename} on Posterous"
    
    add_sass ["posterous"]
  end
end