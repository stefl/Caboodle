module Caboodle
  class Beta < Caboodle::Kit
    
    description "Displays a beta message on every page of the site"
    
    required [:beta_message]
    add_sass ["beta"]
  end
end

Caboodle::Layout.above_header = "<div id='beta'><p>#{Caboodle::Site.beta_message}</p></div>"