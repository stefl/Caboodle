class Caboodle::Standard < Caboodle::Kit
  description "The default home page and site options"
  required [:title, :description, :author]
  optional [:logo_url]
  if Caboodle::Site.home_kit.blank?
    puts "Using the default home kit - you will want to run 'caboodle kit:home <kit name>' to specify your own kit"
    get "/" do
      haml :standard
    end
  end
end
