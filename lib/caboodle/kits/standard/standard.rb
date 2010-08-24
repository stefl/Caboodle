module Caboodle
  class Standard < Caboodle::Kit
    required [:title, :description, :logo_url, :author]
  end
end