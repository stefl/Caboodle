$:<<File.dirname(__FILE__)
$:<<File.join(File.dirname(__FILE__),"caboodle")
%{sinatra/base yaml hashie haml maruku find sinatra/base sinatra/compass sinatra/advanced_routes compass susy pp sleepy caboodle/config caboodle/markdown caboodle/helpers caboodle/config caboodle/kit caboodle/app caboodle/scrape}.split.each{|a| require a}