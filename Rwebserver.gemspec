# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "Rwebserver/version"

Gem::Specification.new do |s|
  s.name        = "Rwebserver"
  s.version     = Rwebserver::VERSION
  s.authors     = ["yafei LI"]
  s.email       = ["lyfi2003@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{a simple file http server by pure ruby code.}
  s.description = %q{a simple file http server by pure ruby code.}

  s.rubyforge_project = "Rwebserver"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
