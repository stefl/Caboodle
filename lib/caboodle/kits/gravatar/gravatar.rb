require 'digest/md5'

class Caboodle::Gravatar < Caboodle::Kit
  
  description "Sets the logo of the site to your gravatar.com image"
  
  optional [:email]
  
  configure do
    if Caboodle::Site.logo_url.to_s.blank? && !Caboodle::Site.email.to_s.blank?
      hash = Digest::MD5.hexdigest(Caboodle::Site.email)
      Caboodle::Site.logo_url = "http://www.gravatar.com/avatar/#{hash}"
    end
  end
end