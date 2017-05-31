module AlexaRuby
  # Amazon Alexa user session
  class Session
    attr_reader :id, :attributes, :end_reason, :error
    attr_accessor :state

    # Initialize new Session
    #
    # @param session [Hash] session parameters
    # @raise [ArgumentError] if user session data is absent
    def initialize(session)
      @session = session
      raise ArgumentError, 'Empty user session' if invalid_session?

      @state = @session[:new] ? :new : :old
      @id = @session[:sessionId]
      @attributes = @session[:attributes] || {}
    end

    # Set session end reason
    #
    # @param reason [String] reason type from Amazon Alexa request
    def end_reason=(reason)
      @end_reason =
        case reason
        when 'USER_INITIATED'
          :user_quit
        when 'ERROR'
          :processing_error
        when 'EXCEEDED_MAX_REPROMPTS'
          :user_idle
        end
    end

    # Set error parameters
    #
    # @param err [Hash] error params
    def error=(err)
      @error = { message: err[:message] }
      @error[:type] =
        case err[:type]
        when 'INVALID_RESPONSE'
          :invalid_alexa_ruby_response
        when 'DEVICE_COMMUNICATION_ERROR'
          :device_error
        when 'INTERNAL_ERROR'
          :runtime_error
        end
    end

    private

    # Check if it is an invalid user session
    #
    # @return [Boolean]
    def invalid_session?
      @session.nil?
    end
  end
end
