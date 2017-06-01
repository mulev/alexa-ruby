require 'coveralls'
require 'minitest/autorun'
require 'minitest/reporters'
require 'alexa_ruby'

Coveralls.wear!
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new(color: true)
