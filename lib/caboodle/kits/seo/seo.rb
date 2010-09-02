class Caboodle::SEO < Caboodle::Kit
  description "Adds basic search engine optimisation"
  add_layout :meta, "<meta type='keywords' value='#{seo_keywords}' /><meta type='description' value='#{seo_description}' />"    
  optional [:seo_keywords,:seo_description]
end