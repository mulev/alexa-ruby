require 'alexa_ruby/session'

# AlexaRuby implements a back-end service for interaction with Amazon Alexa API
module AlexaRuby
  # Abstract request class
  class Request
    attr_accessor :version, :type, :session, :json # global
    attr_accessor :request_id, :locale # on request

    # Initialize new request object and set object parameters
    #
    # @param json [JSON] valid JSON request from Amazon
    def initialize(json)
      @request_id = json[:request][:requestId]
      if @request_id.nil?
        raise ArgumentError, 'Request ID should exist on all Requests'
      end
      @version = json[:version]
      @locale = json[:request][:locale]
      @json = json

      return if @type == :audio_player

      # TODO: We probably need better session handling
      @session = AlexaRuby::Session.new(json[:session])
    end
  end
end
