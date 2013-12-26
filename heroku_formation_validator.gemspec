# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'heroku_formation_validator/version'

Gem::Specification.new do |spec|
  spec.name          = "heroku_formation_validator"
  spec.version       = HerokuFormationValidator::VERSION
  spec.authors       = ["Tomo Nakano"]
  spec.email         = ["tomo@quipper.com"]
  spec.summary       = %q{Heroku config/addons validator for multiple apps}
  spec.description   = %q{Heroku config/addons validator for multiple apps. It checks addons / config varibales etc}
  spec.homepage      = "https://github.com/quipper/heroku_formation_validator"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 10.1"

  spec.add_dependency 'httparty', "~> 0.12"
  spec.add_dependency 'activesupport', "~> 4"
end
