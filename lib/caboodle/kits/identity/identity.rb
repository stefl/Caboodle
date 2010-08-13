module Caboodle

  class Identity < Caboodle::Kit
        
    get "/me" do
      @title = "About me"
      haml :me, :locals=>{:identity=>Identity.new()}, :layout=>true
    end
    
    menu "Me", "/me"
  end
end