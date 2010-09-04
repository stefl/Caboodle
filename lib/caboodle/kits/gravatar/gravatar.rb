require 'digest/md5'

module Caboodle
  class Gravatar < Caboodle::Kit
  
    description "Sets the logo of the site to your gravatar.com image"
  
    optional [:email]
  
    configure do
      if Site.logo_url.to_s.blank? && !Site.email.to_s.blank?
        hash = Digest::MD5.hexdigest(Site.email)
        Site.logo_url = "http://www.gravatar.com/avatar/#{hash}"
      end
    end
  end
end