# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "cascadence"
  gem.homepage = "http://github.com/foxnewsnetwork/cascadence"
  gem.license = "MIT"
  gem.summary = %Q{Organization helper for writing flow-based integration tests using capybara and whatnot}
  gem.description = %Q{Organizational helper for writing serializations for use with threading. The biggest use case of this would be in selenium / capybara based integration testing as this allows you to run flows in parallel.}
  gem.email = "foxnewsnetwork@gmail.com"
  gem.authors = ["Thomas Chen"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "cascadence #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
