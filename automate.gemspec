# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: automate 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "automate"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Lucas Jen\u{df}"]
  s.date = "2015-05-22"
  s.description = "The automate Gem provides a very simple DSL for writing command line automations, providing nice-to-have features such as error handling so that you don't have to implement it over and over again :)"
  s.email = "public@x3ro.de"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "automate.gemspec",
    "examples/git-copy-repo.rb",
    "examples/simple.rb",
    "lib/automate.rb",
    "lib/automate/chain.rb",
    "lib/automate/chain_link.rb",
    "lib/automate/errors.rb",
    "lib/automate/messenger.rb",
    "test/helper.rb",
    "test/test_automate.rb"
  ]
  s.homepage = "http://github.com/x3ro/automate"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Automate helps you automating all your favorite shell tasks"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rainbow>, ["~> 2.0.0"])
      s.add_development_dependency(%q<minitest>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<redcarpet>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<minitest-reporters>, [">= 0"])
      s.add_development_dependency(%q<psych>, [">= 0"])
    else
      s.add_dependency(%q<rainbow>, ["~> 2.0.0"])
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<redcarpet>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<minitest-reporters>, [">= 0"])
      s.add_dependency(%q<psych>, [">= 0"])
    end
  else
    s.add_dependency(%q<rainbow>, ["~> 2.0.0"])
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<redcarpet>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<minitest-reporters>, [">= 0"])
    s.add_dependency(%q<psych>, [">= 0"])
  end
end

