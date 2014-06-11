# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'loggly/version'

Gem::Specification.new do |spec|
  spec.name          = "loggly"
  spec.version       = Loggly::VERSION
  spec.authors       = ["Keith Larrimore", "Brendan Harris"]
  spec.email         = ["klarrimore@icehook.com", "bharris@icehook.com"]
  spec.summary       = %q{Loggly Ruby Client Library}
  spec.description   = %q{Loggly Ruby Client Library}
  spec.homepage      = "https://github.com/icehook/loggly"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rspec', '>= 2.13.0'
  spec.add_development_dependency 'ffaker', '~> 1.15.0'
  spec.add_development_dependency 'machinist', '~> 2.0'
  spec.add_development_dependency 'webmock', '~> 1.9.3'
  spec.add_development_dependency 'guard-rspec', '~> 2.5.0'
  spec.add_development_dependency 'rb-fsevent', '~> 0.9.3'
  spec.add_development_dependency 'simplecov', '~> 0.7.1'
  spec.add_runtime_dependency 'pry', '~> 0.9.12'
  spec.add_runtime_dependency 'activesupport', '~> 4.0.2'
  spec.add_runtime_dependency 'faraday', '~> 0.9.0'
  spec.add_runtime_dependency 'faraday_middleware', '~> 0.9.1'
  spec.add_runtime_dependency 'faraday_middleware-multi_json', '~> 0.0.6'
  spec.add_runtime_dependency 'multi_xml', '~> 0.5.3'
  spec.add_runtime_dependency 'trollop', '~> 2.0.0'
end
