require 'nokogiri'
require 'hashie'

module Caboodle
  def self.scrape url
    ::Nokogiri::HTML(Weary.get(url).perform_sleepily.body)
  end
  
  def self.mash req
    ::Hashie::Mash.new(req.perform_sleepily.parse)
  end
end