module Caboodle
  class Typekit < Caboodle::Kit    
    description "Adds support for Typekit.com CSS options"
    required [:typekit]
    add_sass ["typekit"]
    javascripts ["http://use.typekit.com/#{typekit}.js","/typekit.js"]
  end
end