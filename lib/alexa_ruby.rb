require 'alexa_ruby/request'
require 'alexa_ruby/version'
require 'alexa_ruby/response'
require 'alexa_ruby/intent_request'
require 'alexa_ruby/launch_request'
require 'alexa_ruby/session_ended_request'

module AlexaRuby
  # Prints a JSON object.
  def self.print_json(json)
    p json
  end

  # Prints the Gem version.
  def self.print_version
    p AlexaRubykit::VERSION
  end

  # Returns true if all the Alexa request objects are set.
  def self.valid_alexa?(request_json)
    !request_json.nil? && !request_json['session'].nil? &&
        !request_json['version'].nil? && !request_json['request'].nil?
  end
end
