module Caboodle
  class LazyLoad < Caboodle::Kit
    set :public, File.join(File.dirname(__FILE__), "public")
    javascripts ["jquery.lazyload.mini.js","lazyload.js"]
  end
end