# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{caboodle}
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stef Lewandowski"]
  s.date = %q{2010-09-30}
  s.default_executable = %q{caboodle}
  s.description = %q{Caboodle is a Rack and Sinatra-based framework for creating websites which combine information from various online services. There are Kits for many of the larger services, which provide a way to retrieve and display photos, videos, blog posts, status updates and so on. Caboodle normalises the display of all of these discrete Kits so that you can create a website which looks seamless but is made up of a variety of things from a variety of sources.}
  s.email = %q{stef@stef.io}
  s.executables = ["caboodle"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.textile"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.textile",
     "Rakefile",
     "VERSION",
     "bin/caboodle",
     "lib/.yardoc/checksums",
     "lib/.yardoc/objects/Pago.dat",
     "lib/.yardoc/objects/Pago/App.dat",
     "lib/.yardoc/objects/Pago/MenuItems.dat",
     "lib/.yardoc/objects/Pago/Plugin.dat",
     "lib/.yardoc/objects/Pago/Plugin/is_a_pago_plugin_c.dat",
     "lib/.yardoc/objects/Pago/Plugin/load_all_c.dat",
     "lib/.yardoc/objects/Pago/Plugin/menu_c.dat",
     "lib/.yardoc/objects/Pago/Plugin/use_all_c.dat",
     "lib/.yardoc/objects/Pago/Plugins.dat",
     "lib/.yardoc/objects/Pago/Site.dat",
     "lib/.yardoc/objects/root.dat",
     "lib/.yardoc/proxy_types",
     "lib/caboodle.rb",
     "lib/caboodle/app.rb",
     "lib/caboodle/app/.gems",
     "lib/caboodle/app/config.ru",
     "lib/caboodle/app/config/site.yml",
     "lib/caboodle/app/public/favicon.ico",
     "lib/caboodle/app/public/images/favicon.ico",
     "lib/caboodle/app/public/images/grid.png",
     "lib/caboodle/app/public/js/application.js",
     "lib/caboodle/app/scss/site.scss",
     "lib/caboodle/app/views/error.haml",
     "lib/caboodle/app/views/layout.haml",
     "lib/caboodle/command.rb",
     "lib/caboodle/config.rb",
     "lib/caboodle/config/defaults.yml",
     "lib/caboodle/helpers.rb",
     "lib/caboodle/kit.rb",
     "lib/caboodle/kits/about/about.rb",
     "lib/caboodle/kits/about/config/about.md",
     "lib/caboodle/kits/analytics/analytics.rb",
     "lib/caboodle/kits/beta/beta.rb",
     "lib/caboodle/kits/beta/views/beta.scss",
     "lib/caboodle/kits/broken/broken.rb",
     "lib/caboodle/kits/carbonmade/carbonmade.rb",
     "lib/caboodle/kits/carbonmade/views/carbonmade.scss",
     "lib/caboodle/kits/carbonmade/views/portfolio.haml",
     "lib/caboodle/kits/credits/credits.rb",
     "lib/caboodle/kits/credits/views/credits.haml",
     "lib/caboodle/kits/debugger/debugger.rb",
     "lib/caboodle/kits/disqus/disqus.rb",
     "lib/caboodle/kits/disqus/views/chat.haml",
     "lib/caboodle/kits/feed/config/feed.yml",
     "lib/caboodle/kits/feed/feed.rb",
     "lib/caboodle/kits/feed/views/feed.haml",
     "lib/caboodle/kits/feed/views/feed.scss",
     "lib/caboodle/kits/flickr/flickr.rb",
     "lib/caboodle/kits/flickr/public/galleria.noconflict.min.js",
     "lib/caboodle/kits/flickr/views/photography.haml",
     "lib/caboodle/kits/flickr/views/photography.scss",
     "lib/caboodle/kits/geo/geo.rb",
     "lib/caboodle/kits/github/github.rb",
     "lib/caboodle/kits/github/views/_repo.haml",
     "lib/caboodle/kits/github/views/github.haml",
     "lib/caboodle/kits/googlelocal/config/googlelocal.yml",
     "lib/caboodle/kits/googlelocal/googlelocal.rb",
     "lib/caboodle/kits/googlelocal/views/googlelocal.scss",
     "lib/caboodle/kits/googlelocal/views/near_me.haml",
     "lib/caboodle/kits/gravatar/gravatar.rb",
     "lib/caboodle/kits/history/config/history.yml",
     "lib/caboodle/kits/history/history.rb",
     "lib/caboodle/kits/history/views/history.haml",
     "lib/caboodle/kits/history/views/history.scss",
     "lib/caboodle/kits/identity/identity.rb",
     "lib/caboodle/kits/identity/views/me.haml",
     "lib/caboodle/kits/jquery/jquery.rb",
     "lib/caboodle/kits/lastfm/lastfm.rb",
     "lib/caboodle/kits/lastfm/views/listening.haml",
     "lib/caboodle/kits/lazyload/lazyload.rb",
     "lib/caboodle/kits/lazyload/public/jquery.lazyload.mini.js",
     "lib/caboodle/kits/lazyload/public/lazyload.js",
     "lib/caboodle/kits/linkedin/linkedin.rb",
     "lib/caboodle/kits/linkedin/views/cv.haml",
     "lib/caboodle/kits/linkedin/views/linkedin.scss",
     "lib/caboodle/kits/onepage/onepage.rb",
     "lib/caboodle/kits/onepage/views/contact.haml",
     "lib/caboodle/kits/page/page.rb",
     "lib/caboodle/kits/posterous/posterous.rb",
     "lib/caboodle/kits/posterous/views/_post.haml",
     "lib/caboodle/kits/posterous/views/post.haml",
     "lib/caboodle/kits/posterous/views/posterous.scss",
     "lib/caboodle/kits/posterous/views/posts.haml",
     "lib/caboodle/kits/seo/seo.rb",
     "lib/caboodle/kits/skimmed/skimmed.rb",
     "lib/caboodle/kits/soundcloud/soundcloud.rb",
     "lib/caboodle/kits/soundcloud/views/music.haml",
     "lib/caboodle/kits/standard/standard.rb",
     "lib/caboodle/kits/standard/views/standard.haml",
     "lib/caboodle/kits/susy/susy.rb",
     "lib/caboodle/kits/susy/views/susy/_base.scss",
     "lib/caboodle/kits/susy/views/susy/_defaults.scss",
     "lib/caboodle/kits/susy/views/susy/ie.scss",
     "lib/caboodle/kits/susy/views/susy/print.scss",
     "lib/caboodle/kits/susy/views/susy/screen.scss",
     "lib/caboodle/kits/tumblr/tumblr.rb",
     "lib/caboodle/kits/tumblr/views/_audio.haml",
     "lib/caboodle/kits/tumblr/views/_conversation.haml",
     "lib/caboodle/kits/tumblr/views/_image.haml",
     "lib/caboodle/kits/tumblr/views/_link.haml",
     "lib/caboodle/kits/tumblr/views/_photo.haml",
     "lib/caboodle/kits/tumblr/views/_quote.haml",
     "lib/caboodle/kits/tumblr/views/_regular.haml",
     "lib/caboodle/kits/tumblr/views/_video.haml",
     "lib/caboodle/kits/tumblr/views/tumblr.haml",
     "lib/caboodle/kits/tumblr/views/tumblr.scss",
     "lib/caboodle/kits/twitter/public/images/ajax-loader.gif",
     "lib/caboodle/kits/twitter/public/images/link.png",
     "lib/caboodle/kits/twitter/twitter.rb",
     "lib/caboodle/kits/twitter/views/twitter.haml",
     "lib/caboodle/kits/twitter/views/twitter.scss",
     "lib/caboodle/kits/typekit/public/typekit.js",
     "lib/caboodle/kits/typekit/typekit.rb",
     "lib/caboodle/kits/typekit/views/typekit.scss",
     "lib/caboodle/kits/vimeo/views/vimeo.haml",
     "lib/caboodle/kits/vimeo/vimeo.rb",
     "lib/caboodle/kits/webmaster/webmaster.rb",
     "lib/caboodle/kits/youtube/views/youtube.haml",
     "lib/caboodle/kits/youtube/youtube.rb",
     "lib/caboodle/markdown.rb",
     "lib/caboodle/scrape.rb",
     "test/helper.rb",
     "test/test_caboodle.rb"
  ]
  s.homepage = %q{http://github.com/steflewandowski/caboodle}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Web mashups the simple way}
  s.test_files = [
    "test/helper.rb",
     "test/test_caboodle.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, [">= 1.0"])
      s.add_runtime_dependency(%q<hashie>, [">= 0.2.0"])
      s.add_runtime_dependency(%q<haml>, [">= 3.0.12"])
      s.add_runtime_dependency(%q<compass>, [">= 0.10.2"])
      s.add_runtime_dependency(%q<compass-susy-plugin>, [">= 0.7.0"])
      s.add_runtime_dependency(%q<sinatra-compass>, [">= 0.5.0"])
      s.add_runtime_dependency(%q<sinatra-advanced-routes>, [">= 0.5.1"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.4.0"])
      s.add_runtime_dependency(%q<weary>, [">= 0.7.2"])
      s.add_runtime_dependency(%q<sleepy>, [">= 0.1.4"])
      s.add_runtime_dependency(%q<tumblr-rb>, [">= 0"])
      s.add_runtime_dependency(%q<rack-geo>, [">= 0"])
      s.add_runtime_dependency(%q<maruku>, [">= 0"])
      s.add_runtime_dependency(%q<youtube-g>, [">= 0"])
      s.add_runtime_dependency(%q<feed-normalizer>, [">= 0"])
    else
      s.add_dependency(%q<sinatra>, [">= 1.0"])
      s.add_dependency(%q<hashie>, [">= 0.2.0"])
      s.add_dependency(%q<haml>, [">= 3.0.12"])
      s.add_dependency(%q<compass>, [">= 0.10.2"])
      s.add_dependency(%q<compass-susy-plugin>, [">= 0.7.0"])
      s.add_dependency(%q<sinatra-compass>, [">= 0.5.0"])
      s.add_dependency(%q<sinatra-advanced-routes>, [">= 0.5.1"])
      s.add_dependency(%q<nokogiri>, [">= 1.4.0"])
      s.add_dependency(%q<weary>, [">= 0.7.2"])
      s.add_dependency(%q<sleepy>, [">= 0.1.4"])
      s.add_dependency(%q<tumblr-rb>, [">= 0"])
      s.add_dependency(%q<rack-geo>, [">= 0"])
      s.add_dependency(%q<maruku>, [">= 0"])
      s.add_dependency(%q<youtube-g>, [">= 0"])
      s.add_dependency(%q<feed-normalizer>, [">= 0"])
    end
  else
    s.add_dependency(%q<sinatra>, [">= 1.0"])
    s.add_dependency(%q<hashie>, [">= 0.2.0"])
    s.add_dependency(%q<haml>, [">= 3.0.12"])
    s.add_dependency(%q<compass>, [">= 0.10.2"])
    s.add_dependency(%q<compass-susy-plugin>, [">= 0.7.0"])
    s.add_dependency(%q<sinatra-compass>, [">= 0.5.0"])
    s.add_dependency(%q<sinatra-advanced-routes>, [">= 0.5.1"])
    s.add_dependency(%q<nokogiri>, [">= 1.4.0"])
    s.add_dependency(%q<weary>, [">= 0.7.2"])
    s.add_dependency(%q<sleepy>, [">= 0.1.4"])
    s.add_dependency(%q<tumblr-rb>, [">= 0"])
    s.add_dependency(%q<rack-geo>, [">= 0"])
    s.add_dependency(%q<maruku>, [">= 0"])
    s.add_dependency(%q<youtube-g>, [">= 0"])
    s.add_dependency(%q<feed-normalizer>, [">= 0"])
  end
end

