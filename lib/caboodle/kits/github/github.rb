module Caboodle
  class Github < Caboodle::Kit
        
    description "A single page which links to all of a Github account's public repos"
    
    menu "Code", "/code" do
      @title = "Code"
      @repos = GithubAPI.repositories
      
      @repos.sort!{|a, b| a.watchers <=> b.watchers}.reverse!
      @my_repos = @repos.clone
      @my_repos.delete_if{|a| a.fork }
      
      @forked_repos = @repos.clone
      @forked_repos.delete_if{|a| !a.fork }
      
      haml :github
    end
    
    required [:github_username]
        
    credit "http://github.com/#{Site.github_username}"
  end

  class GithubAPI < Weary::Base
    
      declare "repositories" do |r|
        r.url = "http://github.com/api/v2/json/repos/show/#{Caboodle::Site.github_username}"
        r.via = :get
      end
      
      def self.repositories
        a = Hashie::Mash.new(GithubAPI.new.repositories.perform_sleepily.parse).repositories
        puts a.inspect
        a
      end

  end
end