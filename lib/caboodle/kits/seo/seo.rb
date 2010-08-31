class Caboodle::SEO < Caboodle::Kit
  description "Adds basic search engine optimisation"
  add_layout :meta, "<meta type='keywords' value='#{Caboodle::Site.seo_keywords}' /><meta type='description' value='#{Caboodle::Site.seo_description}' />"    
  optional [:seo_keywords,:seo_description]
end