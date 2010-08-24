module Caboodle
  class Standard < Caboodle::Kit
    required [:title, :description, :logo_url, :author]
    
    get "/" do
      haml "%h2 The default home page"
    end
  end
end