module Caboodle
  class App < Sinatra::Base 
    set :app_file, __FILE__
    set :logging, true
    set :root, File.expand_path(".")
    set :views, Proc.new { File.join(root, "views") }
    set :public, Proc.new { File.join(root, "public") }
    set :run, false
    
    helpers Sinatra::CaboodleHelpers
    
    configure do
      Caboodle::Config.configure_site open(File.expand_path(File.join(Caboodle::App.root,"config","site.yml"))).read
    end
  
  end
end