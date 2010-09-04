class Caboodle::Standard < Caboodle::Kit
  description "The default home page"
  required [:title, :description, :author]
  optional [:logo_url]
  puts "Home kit: #{Caboodle::Site.home_kit}"
  if Caboodle::Site.home_kit.blank? || Caboodle::Site.home_kit =="Standard"
    puts "Using the default home kit - you will want to run 'caboodle kit:home <kit name>' to specify your own kit"
    get "/" do
      haml :standard
    end
  end
end
