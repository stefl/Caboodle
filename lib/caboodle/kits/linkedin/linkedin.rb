module Caboodle
    
  class LinkedinAPI < Weary::Base
    attr_accessor :data
    attr_accessor :full
    
    def initialize
      @full = Caboodle.scrape(Caboodle::Site.linkedin_profile_url)
      @full.css('.showhide-link').each{|a| @full.delete(a)}
      @full = @full.css("#main").to_html.gsub("#{Caboodle::Site.linkedin_full_name}’s ","")
    end
    def method_missing(method_name)
      @data.send(method_name.to_sym)
    end
  end

  class Linkedin < Caboodle::Kit
        
    menu "CV", "/cv" do
      @title = "Curriculum Vitae"
      @linkedin = LinkedinAPI.new #rescue nil
      haml :cv
    end
    
    required [:linkedin_full_name, :linkedin_profile_url]
    
    original Caboodle::Site.linkedin_profile_url
  end
end