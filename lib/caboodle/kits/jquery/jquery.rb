module Caboodle
  class Jquery < Caboodle::Kit
    javascripts ["http://ajax.googleapis.com/ajax/libs/jquery/#{Caboodle::Site.jquery_version || "1.4.2"}/jquery.min.js"]
  end
end