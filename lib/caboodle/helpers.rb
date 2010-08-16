module Sinatra
  module CaboodleHelpers
    
    def method_missing arg
      Caboodle::Layout[arg]
    end
    
    def credit
      #Caboodle::Kit.credit
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
  helpers CaboodleHelpers
end