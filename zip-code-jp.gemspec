# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zip/code/jp/version'

Gem::Specification.new do |spec|
  spec.name          = "zip-code-jp"
  spec.version       = Zip::Code::Jp::VERSION
  spec.authors       = ["itani-hiroki"]
  spec.email         = ["itanihiroki@gmail.com"]
  spec.description   = %q{A Ruby gem for manipulating JP postal codes.}
  spec.summary       = %q{A Ruby gem to handle all things zip code.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
