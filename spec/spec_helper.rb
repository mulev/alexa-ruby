require 'simplecov'
require 'minitest/autorun'
require 'minitest/reporters'
require 'alexa_ruby'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new(color: true)
SimpleCov.start
