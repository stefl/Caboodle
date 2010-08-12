module Caboodle

  class PortfolioApp < Caboodle::Kit
    
    set :views, File.join(File.dirname(__FILE__), "views")
    
    get "/portfolio" do
      @title = "Portfolio"
      haml :portfolio
    end
    
    menu "Portfolio", "/portfolio"
  end
end