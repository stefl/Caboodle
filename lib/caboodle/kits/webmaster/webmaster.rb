module Caboodle
  class Webmaster < Caboodle::Kit
    description "Adds the Google Webmaster metatag to the top of every page of the site"
    required [:webmaster_meta_tag] 
    add_layout :meta, webmaster_meta_tag if webmaster_meta_tag
  end
end