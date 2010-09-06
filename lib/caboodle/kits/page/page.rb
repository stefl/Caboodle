module Caboodle
  class Page < Caboodle::Kit
    
    description "Create markdown pages in the config directory and they are displayed as menu items and pages"

    configure do
      pages = []
      Dir[File.join(Caboodle::App.root,"pages","*.md")].map do |a| 
        pages << a.split("/").last.split(".").first
      end
      
      puts pages.inspect
    
      pages.each do |page|
        puts "Add page: #{page}"
        menu "#{page.capitalize.gsub('_',' ')}" do
          markdown :"#{page}"
        end
      end
    end
  end
end

