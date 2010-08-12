module Caboodle
  class Typekit < Caboodle::Kit
    
    set :public, File.join(File.dirname(__FILE__), "public")
    
    javascripts ["http://use.typekit.com/#{Caboodle::Site.typekit}.js","/typekit.js"]
  
    required [:typekit]
  end
end