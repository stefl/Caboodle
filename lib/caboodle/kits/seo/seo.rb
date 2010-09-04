class Caboodle::SEO < Caboodle::Kit
  description "Adds basic search engine optimisation"
  optional [:seo_keywords,:seo_description]
  add_layout :meta, "<meta type='keywords' value='#{seo_keywords}' />" if seo_keywords
  add_layout :meta, "<meta type='description' value='#{seo_description}' />" if seo_description
end