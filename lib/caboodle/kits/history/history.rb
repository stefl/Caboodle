class Caboodle::History < Caboodle::Kit
    
  description "A list of things you have done in the past."
  
  config_files ["history.yml"]
  
  menu "History"
  
  add_sass ["history"]
    
end