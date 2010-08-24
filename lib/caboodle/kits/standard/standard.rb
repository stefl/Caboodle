module Caboodle
  class Standard < Caboodle::Kit
    required [:title, :description, :logo_url, :author]
    
    get "/" do
      "The default home page"
    end
  end
end