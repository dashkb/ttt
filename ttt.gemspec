# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ttt/version'

Gem::Specification.new do |spec|
  spec.name          = "ttt"
  spec.version       = TTT::VERSION
  spec.authors       = ["Kyle Brett"]
  spec.email         = ["kyle@kylebrett.com"]
  spec.description   = %q{tic tac toe}
  spec.summary       = %q{tac tac tac}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec"

  spec.add_dependency "thor"
  spec.add_dependency "grit"
  spec.add_dependency "colorize"
end
