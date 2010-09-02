module Caboodle
  class Typekit < Caboodle::Kit    
    description "Adds support for Typekit.com CSS options"
    javascripts ["http://use.typekit.com/#{typekit}.js","/typekit.js"]
    required [:typekit]
    add_sass ["typekit"]
  end
end