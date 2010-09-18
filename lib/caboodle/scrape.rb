require 'nokogiri'
require 'hashie'
require 'net/http'
require 'open-uri'

module Caboodle
  
  begin
    require 'memcached'
    CACHE = Memcached.new
    puts "Running with memcache"
  rescue
    puts "Running without memcache"
  end
  
  def self.round_time(integer, factor)
    return integer if(integer % factor == 0)
    return integer - (integer % factor)
  end
  
  def self.scrape url
    begin
      if defined?(CACHE)
        puts "Scraping with cache optimisation"
        timeout = 60*60*1000
        response = CACHE.get("#{round_time(Time.new.to_i, timeout)}:#{url}") rescue nil
        response ||= open(url).read
        CACHE.set("#{round_time(Time.new.to_i, timeout)}:#{url}", response)
        CACHE.set("0:#{url}", response)
      else
        puts "Scraping without cache optimisation"
        response = open(url).read
      end
      ::Nokogiri::HTML(response)
    rescue Exception => e
      puts e.inspect
      if defined?(CACHE)
        response = CACHE.get("0:#{url}")
      end
      response ||= ""
      ::Nokogiri::HTML(response)
    end
  end
  
  def self.mash req
    ::Hashie::Mash.new(req.perform_sleepily.parse)
  end
  
  def self.extract_feed url
    Caboodle::FeedDetector.fetch_feed_url url
  end
  
  class FeedDetector

    ##
    # return the feed url for a url
    # for example: http://blog.dominiek.com/ => http://blog.dominiek.com/feed/atom.xml
    # only_detect can force detection of :rss or :atom
    def self.fetch_feed_url(page_url, only_detect=nil)
      url = URI.parse(page_url)
      host_with_port = url.host
      host_with_port << ":#{url.port}" unless url.port == 80

      res = Weary.get(page_url).perform_sleepily

      feed_url = self.get_feed_path(res.body, only_detect)
      "http://#{host_with_port}/#{feed_url.gsub(/^\//, '')}" unless !feed_url || feed_url =~ /^http:\/\//
    end

    ##
    # get the feed href from an HTML document
    # for example:
    # ...
    # <link href="/feed/atom.xml" rel="alternate" type="application/atom+xml" />
    # ...
    # => /feed/atom.xml
    # only_detect can force detection of :rss or :atom
    def self.get_feed_path(html, only_detect=nil)
      unless only_detect && only_detect != :atom
        md ||= /<link.*href=['"]*([^\s'"]+)['"]*.*application\/atom\+xml.*>/.match(html)
        md ||= /<link.*application\/atom\+xml.*href=['"]*([^\s'"]+)['"]*.*>/.match(html)
      end
      unless only_detect && only_detect != :rss
        md ||= /<link.*href=['"]*([^\s'"]+)['"]*.*application\/rss\+xml.*>/.match(html)
        md ||= /<link.*application\/rss\+xml.*href=['"]*([^\s'"]+)['"]*.*>/.match(html)
      end
      md && md[1]
    end

  end
  
end