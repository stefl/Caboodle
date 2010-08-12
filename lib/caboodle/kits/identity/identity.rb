module Caboodle
  
  class Identity
  
  end

  class IdentityApp < Caboodle::Kit
    
    set :views, File.join(File.dirname(__FILE__), "views")
    
    get "/me" do
      @title = "About me"
      haml :me, :locals=>{:identity=>Identity.new()}, :layout=>true
    end
    
    menu "Me", "/me"
  end
end