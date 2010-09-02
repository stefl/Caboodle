module Caboodle
    
  class LinkedinAPI < Weary::Base
    attr_accessor :data
    attr_accessor :full
    
    def initialize
      @full = Caboodle.scrape(Site.linkedin_profile_url)
      @full.css('.showhide-link').each{|a| @full.delete(a)}
      @full = @full.css("#main").to_html.gsub("#{Site.linkedin_full_name}’s ","")
    end
    def method_missing(method_name)
      @data.send(method_name.to_sym)
    end
  end

  class Linkedin < Caboodle::Kit
        
    description "Displays a Linkedin profile as a CV with consistent layout with the rest of the site."

    menu "CV" do
      @linkedin = LinkedinAPI.new
      haml :cv
    end
    
    required [:linkedin_full_name, :linkedin_profile_url]
    
    credit linkedin_profile_url, "Linkedin profile"
    
    add_sass ["linkedin"]
    
  end
end