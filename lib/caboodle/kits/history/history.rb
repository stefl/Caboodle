module Caboodle
  class History < Caboodle::Kit
        
    configure do
      config_path = File.expand_path(File.join(Caboodle::App.root,"config","history.yml"))
      if File.exists?(config_path)
        Caboodle::Kit.load_config(config_path)
      else
        `cp "#{File.join(File.dirname(__FILE__),"config","history.yml")}" "#{File.join(Caboodle::App.root,"config",".")}"` rescue "Could not create the sample yml file"
        puts "Please enter your history items in the file #{File.expand_path(File.join(Caboodle::App.root,"config","history.yml"))}"
      end
    end
        
    menu "History", "/history" do
      @title = "History"
      haml :history
    end
    
  end
end