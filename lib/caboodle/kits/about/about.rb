require 'maruku'

module Caboodle
  class About < Caboodle::Kit
    
    description "Gives you an About page at /about. Edit the Markdown file located in your application config directory."
    
    files ["about.md"]
    
    config_files ["about.yml"]
    
    menu "About", "/about" do
      md = File.expand_path(File.join(Caboodle::App.root,"config","about.md"))
      @content = Maruku.new(open(md).read).to_html_document
      haml ".page.about= @content"
    end
  end
end