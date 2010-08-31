class Caboodle::Jquery < Caboodle::Kit
  description "Adds Jquery to every page of the site"
  javascripts ["http://ajax.googleapis.com/ajax/libs/jquery/#{Caboodle::Site.jquery_version || "1.4.2"}/jquery.min.js"]
end