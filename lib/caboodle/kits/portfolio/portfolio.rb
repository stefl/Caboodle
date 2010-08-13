module Caboodle
  class PortfolioApp < Caboodle::Kit
        
    get "/portfolio" do
      @title = "Portfolio"
      haml :portfolio
    end
    
    menu "Portfolio", "/portfolio"
  end
end