module Caboodle
  class App < Sinatra::Base 
    set :app_file, __FILE__
    set :logging, true
    set :root, File.expand_path(".")
    set :views, Proc.new { File.join(root, "views") }
    set :public, Proc.new { File.join(root, "public") }
    set :run, false
    set :root_config, File.expand_path(File.join(Caboodle::App.root,"config","site.yml"))
    
    helpers do
      def method_missing arg
        Caboodle::Layout[arg]
      end

      def title
        if request.path_info == "/"
          "#{Caboodle::Site.title} | #{Caboodle::Site.description}"
        else
          t = Caboodle::Site.title
          t = "#{@title} | #{t}" if @title
        end
      end
    end
    
    configure do
      Caboodle::Kit.configure_site root_config if File.exists?(root_config)
    end
  
  end
end