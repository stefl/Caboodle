module Caboodle
  
  
  class App < Sinatra::Base
    #register Sinatra::Compass
      
    set :app_file, __FILE__
    set :logging, true
    set :root, File.expand_path(".")
    set :views, Proc.new { File.join(root, "views") }
    set :public, Proc.new { File.join(root, "public") }
    #disable :run, :reload
    # set :compass, :sass_dir => File.join(root, "stylesheets")
    #   
    # get_compass("/css/:name.css") do
    #   compass :one_stylesheet
    # end
    
    helpers Sinatra::ContentFor
  
    configure do
      config_path = File.expand_path(File.join(root,"site.yml"))
      if File.exists?(config_path)
        Caboodle::Kit.load_config(config_path)
        Caboodle::Kit.setup
      end
      
      puts Caboodle::Site.inspect
    end
    # get '/:kit/stylesheet.css' do
    #   header 'Content-Type' => 'text/css; charset=utf-8'
    #   sass :stylesheet
    # end
  
  end
end