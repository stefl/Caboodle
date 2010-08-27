gem "tumblr-rb"
require 'tumblr'

module Caboodle
  class Tumblr < Caboodle::Kit   
     
    helpers do
      def semantic_date post
        date = Date.parse(post.date)
        a = []
        a << "slug-#{post.slug}"
        a << "y#{date.year}"
        a << "m#{date.month}"
        a << "d#{date.day}"
        a.join(" ")
      end
    end
     
    required [:tumblr_email, :tumblr_password, :tumblr_sitename]
    
    menu "Tumblr", "/tumblr" do
      puts "Get tumblr"
      tumblr = ::Tumblr::Reader.new(Caboodle::Site.tumblr_email,Caboodle::Site.tumblr_password)
      req = tumblr.read(Caboodle::Site.tumblr_sitename, {:num=>10}).perform_sleepily
      puts req.inspect
      posts = ::Tumblr::Reader.get_posts(req)
      puts posts.inspect

      #posts = tumblr.get_posts(result)
      haml :tumblr, :locals => { :posts => posts }
    end
    
    get "/tumblr/page/:page" do
      tumblr = ::Tumblr::Reader.new(Caboodle::Site.tumblr_email,Caboodle::Site.tumblr_password)
      result
      posts = tumblr.get_posts()
      haml :tumblr, :locals => { :posts => posts }
    end
    
    add_sass ["tumblr"]
    
  end
end