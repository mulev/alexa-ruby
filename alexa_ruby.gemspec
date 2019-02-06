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
  spec.homepage      = 'https://github.com/mulev/alexa-ruby'
  spec.license       = 'MIT'
  spec.files         = Dir['[A-Z]*'] + Dir['lib/**/*'] + Dir['spec/**'] + Dir['bin/**']
  spec.files.reject!   { |fn| fn.include?('.gem') }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency     'bundler', '>= 1.6.9'
  spec.add_runtime_dependency     'rake'
  spec.add_runtime_dependency     'addressable', '>= 2.5.1'
  spec.add_runtime_dependency     'httparty', '>= 0.15.5'

  spec.add_development_dependency 'minitest', '~> 5.10', '>= 5.10.2'
  spec.add_development_dependency 'minitest-reporters', '~> 1.1', '>= 1.1.14'
end
