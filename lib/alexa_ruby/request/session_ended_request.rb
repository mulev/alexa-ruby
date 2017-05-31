# Session end request class.
module AlexaRuby
  # Amazon "SessionEndedRequest" request type
  class SessionEndedRequest < BaseRequest
    # Initialize new SessionEndedRequest
    #
    # @param request [Hash] valid request from Amazon Alexa service
    def initialize(request)
      @type = :session_ended
      super
      finalize_session
    end

    private

    # Set final session params
    def finalize_session
      @session.state = :ended
      @session.end_reason = @req[:request][:reason]
      @session.error = @req[:request][:error] unless @req[:request][:error].nil?
    end
  end
end
