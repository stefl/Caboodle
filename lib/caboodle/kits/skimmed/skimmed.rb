module Caboodle
  class Skimmed < Caboodle::Kit
    javascripts ["http://skimlinks.com/js/#{Site.skimmed}.js"]
    required [:skimmed]
  end
end