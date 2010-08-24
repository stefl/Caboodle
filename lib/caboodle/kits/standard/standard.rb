module Caboodle
  class Standard < Caboodle::Kit
    required [:title, :description, :logo_url, :author]
    
    if Caboodle::Site.home_kit.to_s.blank?   
      get "/" do
        haml :standard
      end
    end
  end
end