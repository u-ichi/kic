# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "kic"
  gem.version     = File.read("VERSION").strip
  gem.authors     = ["Yuichi UEMURA"]
  gem.email       = ["yuichi.u@gmail.com"]
  gem.homepage    = "https://github.com/u-ichi/kic"
  gem.summary     = %q{Kick QueryAPI}
  gem.description = %q{Kick QueryAPI}

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rake"
end

