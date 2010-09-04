module Sinatra
  class Base
    def markdown sym
      md = File.expand_path(File.join(Caboodle::App.root,"config","#{sym.to_s}.md"))
      @content = Maruku.new(open(md).read).to_html_document
      haml ".page.about.thin_page= @content"
    end
  end
end