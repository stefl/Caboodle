module Sinatra
  module CaboodleHelpers
    
    def method_missing arg
      Caboodle::Layout[arg]
    end
    
    def credit
      #Caboodle::Kit.credit
    end
    
  end
  helpers CaboodleHelpers
end