module Caboodle
  class App < Sinatra::Base 
    set :app_file, __FILE__
    set :logging, true
    set :root, File.expand_path(".")
    set :views, Proc.new { File.join(root, "views") }
    set :public, Proc.new { File.join(root, "public") }
    
    helpers Sinatra::CaboodleHelpers
    
    configure do
      Caboodle::Kit.configure_site File.expand_path(File.join(Caboodle::App.root,"config","site.yml"))
    end
  
  end
end