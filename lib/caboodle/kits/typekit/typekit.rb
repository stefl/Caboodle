module Caboodle
  class Typekit < Caboodle::Kit    
    description "Adds support for Typekit.com CSS options"
    javascripts ["http://use.typekit.com/#{Caboodle::Site.typekit}.js","/typekit.js"]
    required [:typekit]
    add_sass ["typekit"]
  end
end