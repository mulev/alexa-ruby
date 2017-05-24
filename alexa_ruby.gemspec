# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alexa_ruby/version'

Gem::Specification.new do |spec|
  spec.name          = 'alexa_ruby'
  spec.version       = AlexaRuby::VERSION
  spec.authors       = ['Mike Mulev']
  spec.email         = ['m.mulev@gmail.com']
  spec.summary       = 'Ruby toolkit for Amazon Alexa API'
  spec.description   = 'Ruby toolkit for Amazon Alexa API'
  spec.homepage      = ''
  spec.license       = 'MIT'
  spec.files         = Dir['[A-Z]*'] + Dir['lib/**/*'] + Dir['tests/**'] + Dir['bin/**']
  spec.files.reject!   { |fn| fn.include?('.gem') }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.add_runtime_dependency 'bundler', '~> 1.7'
  spec.add_runtime_dependency 'rake'
  spec.add_runtime_dependency 'oj', '~> 3.0'
  spec.add_development_dependency 'rspec', '~> 3.2', '>= 3.2.0'
  spec.add_development_dependency 'rspec-mocks', '~> 3.2', '>= 3.2.0'
end
