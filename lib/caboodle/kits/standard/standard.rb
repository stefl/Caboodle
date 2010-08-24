module Caboodle
  class Standard < Caboodle::Kit
    required [:title, :description, :logo_url, :author]
    puts "Test home kit"
    if Caboodle::Site.home_kit.blank? || !(Caboodle::Kit.available_kits.include?(Caboodle::Site.home_kit)) || !(Caboodle::Kits.include?(Caboodle::Site.home_kit))
      puts "There is no home page kit"
      get "/" do
        haml :standard
      end
    end
  end
end