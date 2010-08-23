module Caboodle
  class App < Sinatra::Base 

        
    set :app_file, __FILE__
    set :logging, true
    set :root, File.expand_path(".")
    set :views, Proc.new { File.join(root, "views") }
    set :public, Proc.new { File.join(root, "public") }
    #disable :run, :reload
    
    set :compass, :sass_dir => File.join(File.dirname(__FILE__),"app","views","stylesheets") 
    register Sinatra::Compass
    set :compass, :sass_dir => File.join(File.dirname(__FILE__),"app","views","stylesheets")
    
    helpers Sinatra::CaboodleHelpers
  
    configure do
      config_path = File.expand_path(File.join(root,"config","site.yml"))
      if File.exists?(config_path)
        Caboodle::Kit.load_config(config_path)
        Caboodle::Kit.setup
      end      
    end
    
    puts "**** compass"
    
    get("/foo/screen.css") do
      puts "**** compass"
      compass :screen
    end
    
    # 
    # get("/stylesheets/:name.css") do
    #   content_type 'text/css', :charset => 'utf-8'
    #   #sass :"stylesheets/#{params[:name]}", :sass_dir => File.join(File.dirname(__FILE__),"views","stylesheets")
    #   ::Sass::Engine.new(open(File.expand_path(File.join(File.dirname(__FILE__),"app","views","stylesheets","#{params[:name]}.scss"))).read, {:syntax=>:scss}).render
    # end
    
    # get '/:kit/stylesheet.css' do
    #   header 'Content-Type' => 'text/css; charset=utf-8'
    #   sass :stylesheet
    # end
  
  end
end