require 'oj'

require 'alexa_ruby/request'
require 'alexa_ruby/version'
require 'alexa_ruby/response'
require 'alexa_ruby/request/intent_request'
require 'alexa_ruby/request/launch_request'
require 'alexa_ruby/request/session_ended_request'
require 'alexa_ruby/request/audio_player_request'

# AlexaRuby implements a back-end service for interaction with Amazon Alexa API
module AlexaRuby
  class << self
    # Prints some JSON
    #
    # @param json [JSON] some JSON object
    def print_json(json)
      p json
    end

    # Prints the Gem version
    def print_version
      p AlexaRuby::VERSION
    end

    # Builds a new request for Alexa
    #
    # @param json_request [JSON] json request from Amazon Alexa
    # @return [Object] instance of request class
    def build_request(json_request)
      json = load_json(json_request)

      unless AlexaRuby.valid_request?(json)
        raise ArgumentError, 'Invalid Alexa Request'
      end

      @request = define_request(json)
      raise ArgumentError, 'Invalid Request Type' if @request.nil?
      @request
    end

    # Check if it is a valid Amazon Alexa request
    #
    # @param json [JSON] json request from Amazon Alexa
    # @return [Boolean]
    def valid_request?(json)
      session =
        if json[:request].nil? || /AudioPlayer/.match(json[:request][:type])
          true
        else
          !json[:session].nil?
        end
      !json.nil? && session && !json[:version].nil? && !json[:request].nil?
    end

    # Define proper request class and instantinate it
    #
    # @param json [JSON] json request from Amazon Alexa
    # @return [Object] instance of request class
    def define_request(json)
      case json[:request][:type]
      when /Launch/
        LaunchRequest.new(json)
      when /Intent/
        IntentRequest.new(json)
      when /SessionEnded/
        SessionEndedRequest.new(json)
      when /AudioPlayer/
        AudioPlayerRequest.new(json)
      end
    end

    private

    # Parse JSON request, validate it and convert it to hash
    #
    # @param request [String] json request from Amazon Alexa
    # @return [Hash] loaded and validated request
    def load_json(request)
      Oj.load(request, symbol_keys: true)
    rescue StandardError
      raise ArgumentError, 'Invalid JSON in request'
    end
  end
end
