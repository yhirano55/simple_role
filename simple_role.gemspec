# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "simple_role/version"

Gem::Specification.new do |s|
  s.name        = "simple_role"
  s.version     = SimpleRole::VERSION
  s.authors     = ["Yoshiyuki Hirano"]
  s.email       = ["yhirano@me.com"]
  s.homepage    = 'https://github.com/yhirano55/simple_role'
  s.summary     = %q{Magical Authorization for Rails}
  s.description = %q{Magical Authorization for Rails}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
