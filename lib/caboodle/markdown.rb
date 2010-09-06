module Sinatra
  class Base
    def markdown sym
      md = File.expand_path(File.join(Caboodle::App.root,"config","#{sym.to_s}.md"))
      unless File.exists?(md)
        md = File.expand_path(File.join(Caboodle::App.root,"pages","#{sym.to_s}.md"))
      end
      if File.exists?(md)
        @content = Maruku.new(open(md).read).to_html_document
        haml ".page.#{sym.to_s}.thin_page= @content"
      else
        haml "%h2.#{sym.to_s}= 'Sorry - #{sym.to_s}.md was not found"
      end
    end
  end
end