class Caboodle::Beta < Caboodle::Kit
  
  description "Displays a beta message on every page of the site"
  
  required [:beta_message]
  
  add_sass ["beta"]
  
  add_layout :above_header, "<div id='beta'><p>#{beta_message}</p></div>"
end