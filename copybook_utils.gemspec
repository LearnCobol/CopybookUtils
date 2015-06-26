# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'copybook_utils/version'

Gem::Specification.new do |spec|
  spec.name          = "copybook_utils"
  spec.version       = CopybookUtils::VERSION
  spec.authors       = ["Glenn Waters"]
  spec.email         = ["gwwaters@gmail.com"]

  spec.summary       = %q{Utilities for working with COBOL copybooks and file conversion.}
  spec.homepage      = "https://github.com/gwww/CopybookUtils"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.extensions    << "ext/convert_methods/extconf.rb"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rake-compiler", "~> 0.9"
end
