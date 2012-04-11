# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "capistrano-scm-bamboo/version"

Gem::Specification.new do |s|
  s.name        = "capistrano-scm-bamboo"
  s.version     = Capistrano::Scm::Bamboo::VERSION
  s.authors     = ["John Knight"]
  s.email       = ["bug@knightlabs.com"]
  s.homepage    = "https://github.com/knightlabs/capistrano-scm-bamboo"
  s.summary     = %q{Use Atlassian Bamboo as a Capistrano SCM strategy}
  s.description = %q{
With this plugin, you can use Bamboo build artifacts as a repository, and
deploy your build artifact with Capistrano.
  }

  s.rubyforge_project = "capistrano-scm-bamboo"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_runtime_dependency "capistrano"
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "typhoeus"
  s.add_development_dependency "rspec"
end
