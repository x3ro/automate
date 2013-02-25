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
  gem.name = "automate"
  gem.homepage = "http://github.com/x3ro/automate"
  gem.license = "MIT"
  gem.summary = %Q{Automate helps you automating all your favorite shell tasks}
  gem.description = %Q{The automate Gem provides a very simple DSL for writing command line automations, providing nice-to-have features such as error handling so that you don't have to implement it over and over again :)}
  gem.email = "public@x3ro.de"
  gem.authors = ["Lucas Jenß"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'yard'
YARD::Rake::YardocTask.new
