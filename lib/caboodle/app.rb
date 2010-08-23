module Caboodle
  class App < Sinatra::Base 

    set :app_file, __FILE__
    set :logging, true
    set :root, File.expand_path(".")
    set :views, Proc.new { File.join(root, "views") }
    set :public, Proc.new { File.join(root, "public") }
    
    helpers Sinatra::CaboodleHelpers
    
    configure do
      config_path = File.expand_path(File.join(root,"config","site.yml"))
      if File.exists?(config_path)
        Caboodle::Kit.load_config(config_path)
        Caboodle::Kit.setup
      end      
    end
  
  end
end