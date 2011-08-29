# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "architect4r/version"

Gem::Specification.new do |s|
  s.name        = "architect4r"
  s.version     = Architect4r::VERSION
  s.authors     = ["Maximilian Schulz"]
  s.email       = ["max@jungeelite.de"]
  s.homepage    = "http://max.jungeelite.de/"
  s.summary     = %q{A gem for working with the neo4j REST interface.}
  s.description = %q{This gem is intended for making a neo4j graph db accessible by providing a ruby wrapper for the REST API.}
  
  s.rubyforge_project = "architect4r"
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  # Development dependencies
  s.add_development_dependency "rspec"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "rb-fsevent"
  s.add_development_dependency "growl"
  
  # Production dependencies
  s.add_runtime_dependency "activemodel"
  s.add_runtime_dependency "active_support"
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "typhoeus"
end