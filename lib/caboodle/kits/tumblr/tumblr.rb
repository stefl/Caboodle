gem "tumblr-rb"
require 'tumblr'

module Caboodle
  class Tumblr < Caboodle::Kit   
    description "Includes a tumblr.com account"
  
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
  
    menu "Tumblr" do
      tumblr = ::Tumblr::Reader.new(@tumblr_email,@tumblr_password)
      req = tumblr.read(@tumblr_sitename, {:num=>10}).perform_sleepily
      posts = ::Tumblr::Reader.get_posts(req)
      haml :tumblr, :locals => { :posts => posts }
    end
  
    get "/tumblr/page/:page" do
      tumblr = ::Tumblr::Reader.new(@tumblr_email,@tumblr_password)
      posts = tumblr.get_posts()
      haml :tumblr, :locals => { :posts => posts }
    end
  
    add_sass ["tumblr"]
  end
end