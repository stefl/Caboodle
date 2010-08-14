module Caboodle
  class Portfolio < Caboodle::Kit
        
    configure do
      config_path = File.expand_path(File.join(Caboodle::App.root,"config","portfolio.yml"))
      if File.exists?(config_path)
        Caboodle::Kit.load_config(config_path)
      else
        `cp "#{File.join(File.dirname(__FILE__),"config","portfolio.yml")}" "#{File.join(Caboodle::App.root,"config",".")}"` rescue "Could not create the sample yml file"
        puts "Please enter your portfolio items in the file #{File.expand_path(File.join(Caboodle::App.root,"config","portfolio.yml"))}"
      end
    end
        
    get "/portfolio" do
      @title = "Portfolio"
      haml :portfolio
    end
    
    menu "Portfolio", "/portfolio"
  end
end