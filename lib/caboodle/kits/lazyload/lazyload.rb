module Caboodle
  class LazyLoad < Caboodle::Kit
    description "Improves page load times for javascript-enabled browsers by loading images on demand as the user scrolls the page."
    javascripts ["/jquery.lazyload.mini.js","/lazyload.js"]
  end
end