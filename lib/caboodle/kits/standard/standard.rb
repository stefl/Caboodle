module Caboodle
  class Standard < Caboodle::Kit
    required [:title, :description, :author]
    optional [:logo_url]
    if Caboodle::Site.home_kit.blank? || !(Caboodle::Kit.available_kits.include?(Caboodle::Site.home_kit)) || !(Caboodle::Kits.include?(Caboodle::Site.home_kit))
      puts "Using the default home kit - you will want to run 'caboodle kit:home <kit name>' to specify your own kit"
      get "/" do
        haml :standard
      end
    end
  end
end