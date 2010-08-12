require 'haml'

module Caboodle
  Pages = []
  class Page
  
    attr_accessor :slug
    attr_accessor :body
    attr_accessor :file
  
    def initialize slug
      @slug = slug
    end
  
    def file
      @file ||= File.new(Dir[File.join(File.dirname(__FILE__),"pages","#{@slug}.haml")].first)
    end
  
    def self.all
      return Caboodle::Pages unless Caboodle::Pages.empty?
      Dir[File.join(File.dirname(__FILE__),"pages","*.haml")].map do |a| 
        p = Page.new(a.split("/").last.gsub(".haml",""))
        Caboodle::Pages << p
        Caboodle::MenuItems << {:display=>p.title, :link=>p.link}
      end
      
      return Caboodle::Pages
    end
  
    def self.get slug
      STDERR.puts "Get page: #{slug}"
      return nil unless Caboodle::Pages.map{|a| a.slug}.include?(slug)
      Page.new(slug.gsub(" ", "_"))
    end
  
    def body
      @body ||= file.read
    end
  
    def to_html
      Haml::Engine.new(body).render
    end
  
    def title
      @slug.gsub("_","").capitalize
    end
    
    def link
      "/#{slug}"
    end
  
  end
  
  class PageApp < Caboodle::Kit
    
    set :views, File.join(File.dirname(__FILE__), "views")
    
    Caboodle::Site.pages = Caboodle::Page.all
    Caboodle::Site.pages.each do |page|
      get "/#{page.slug}" do
        @page = Page.get(request.path_info.gsub("/",""))
        pass if @page.blank?
        @title = @page.title
        haml :page, :locals => {:page => @page}
      end
    end
  end
end

