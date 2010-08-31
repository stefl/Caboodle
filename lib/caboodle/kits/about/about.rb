class Caboodle::About < Caboodle::Kit
  
  description "Gives you an About page at /about. Edit the Markdown file located in your application config directory."
  
  files ["about.md"]
      
  menu "About", "/about" do
    markdown :about
  end
end