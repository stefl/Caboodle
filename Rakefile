require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "caboodle"
    gem.summary = "Web mashups the simple way"
    gem.description = "Caboodle is a Rack and Sinatra-based framework for creating websites which combine information from various online services. There are Kits for many of the larger services, which provide a way to retrieve and display photos, videos, blog posts, status updates and so on. Caboodle normalises the display of all of these discrete Kits so that you can create a website which looks seamless but is made up of a variety of things from a variety of sources."
    gem.email = "stef@stef.io"
    gem.homepage = "http://github.com/steflewandowski/caboodle"
    gem.authors = ["Stef Lewandowski"]
    gem.add_dependency "sinatra", ">=1.0"
    gem.add_dependency "hashie", ">=0.2.0"
    gem.add_dependency "haml", ">=3.0.12"
    gem.add_dependency "compass", ">=0.10.2"
    gem.add_dependency "compass-susy-plugin", ">=0.7.0"
    gem.add_dependency "sinatra-compass", ">=0.5.0"
    gem.add_dependency "sinatra-advanced-routes", ">=0.5.1"
    gem.add_dependency "nokogiri",">=1.4.0"
    gem.add_dependency "weary",">=0.7.2"
    gem.add_dependency "sleepy",">=0.1.4"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "caboodle #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
