# Utilities
require 'addressable/uri'
require 'securerandom'
require 'json'
require 'ostruct'

# Gem core
require 'alexa_ruby/alexa'
require 'alexa_ruby/request/base_request'
require 'alexa_ruby/request/base_request/context'
require 'alexa_ruby/request/base_request/context/audio_state'
require 'alexa_ruby/request/base_request/context/device'
require 'alexa_ruby/request/base_request/session'
require 'alexa_ruby/request/base_request/validator'
require 'alexa_ruby/request/base_request/validator/uri'
require 'alexa_ruby/request/base_request/validator/certificates'
require 'alexa_ruby/request/base_request/user'
require 'alexa_ruby/request/audio_player_request'
require 'alexa_ruby/request/launch_request'
require 'alexa_ruby/request/intent_request'
require 'alexa_ruby/request/intent_request/slot'
require 'alexa_ruby/request/intent_request/resolution_authority'
require 'alexa_ruby/request/session_ended_request'
require 'alexa_ruby/response/response'
require 'alexa_ruby/response/audio_player'
require 'alexa_ruby/response/card'
require 'alexa_ruby/version'

# AlexaRuby implements a back-end service for interaction with Amazon Alexa API
module AlexaRuby
  class << self
    # Validate HTTP/S request body and initialize new Alexa Assistant
    #
    # @param request [Object] request from Amazon Alexa web service,
    #                         can be hash or JSON encoded string
    # @param opts [Hash] additional options:
    #   :disable_validations [Boolean] disables request validation if true
    #   :certificates_chain_url [String] URL of Amazon SSL certificates chain
    #   :request_signature [String] Base64-encoded request signature
    # @return [Object] new Request object instance
    # @raise [ArgumentError] if given object isn't a valid JSON object
    def new(request, opts = {})
      obj = build_json(request)
      Alexa.new(obj, opts)
    end

    private

    # Build JSON from received request
    #
    # @param obj [Object] request from Amazon Alexa web service,
    #                     can be hash or JSON encoded string
    # @return [Hash] valid builded JSON
    # @raise [ArgumentError] if given object isn't a valid JSON object
    def build_json(obj)
      obj = JSON.generate(obj) if hash?(obj)
      JSON.parse(obj, symbolize_names: true)
    rescue StandardError
      raise ArgumentError, 'Request must be a valid JSON object'
    end

    # Check if object is a Hash or not
    #
    # @param obj [Object] some object
    # @return [Boolean]
    def hash?(obj)
      obj.is_a? Hash
    end
  end
end
