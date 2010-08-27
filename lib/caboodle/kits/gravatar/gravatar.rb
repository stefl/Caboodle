require 'digest/md5'

module Caboodle
  class Standard < Caboodle::Kit
    required [:email]
    
    configure do
      unless Caboodle::Site.logo_url
        hash = Digest::MD5.hexdigest(Caboodle::Site.email)
        Caboodle::Site.logo_url = "http://www.gravatar.com/avatar/#{hash}"
      end
    end
  end
end