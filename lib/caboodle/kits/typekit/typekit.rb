module Caboodle
  class Typekit < Caboodle::Kit    
    javascripts ["http://use.typekit.com/#{Caboodle::Site.typekit}.js","/typekit.js"]
    required [:typekit]
  end
end