module Sinatra
  module CaboodleHelpers
    
    def method_missing arg
      Caboodle::Layout[arg]
    end
    
  end
  helpers CaboodleHelpers
end