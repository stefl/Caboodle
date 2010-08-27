require 'digest/md5'

module Caboodle
  class Standard < Caboodle::Kit
    optional [:email]
    
    configure do
      if Caboodle::Site.logo_url.to_s.blank? && !Caboodle::Site.email.to_s.blank?
        hash = Digest::MD5.hexdigest(Caboodle::Site.email)
        Caboodle::Site.logo_url = "http://www.gravatar.com/avatar/#{hash}"
      end
    end
  end
end