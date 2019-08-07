# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "swn/revised/version"

Gem::Specification.new do |spec|
  spec.name          = "swn-revised"
  spec.version       = Swn::Revised::VERSION
  spec.authors       = ["Jeremy Friesen"]
  spec.email         = ["jeremy.n.friesen@gmail.com"]

  spec.summary       = %q{A suite of tools for extracting tables from Stars without Number EPUB}
  spec.description   = %q{A command line tool for GM-ing}
  spec.homepage      = "https://github.com/jeremyf/swn-revised"
  spec.license       = "APACHE2"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dry-initializer"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "simplecov"
end
