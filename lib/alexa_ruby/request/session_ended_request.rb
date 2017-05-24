# Session end request class.
module AlexaRuby
  # Class for Amazon "SessionEndedRequest" request type
  class SessionEndedRequest < Request
    attr_accessor :reason

    # Initialize new SessionEndedRequest
    #
    # @param json [JSON] valid JSON request from Amazon
    def initialize(json)
      @type = :session_ended
      @reason = json[:request][:reason]
      super
    end

    # Ouputs the request_id and the reason of session end
    #
    # @return [String] request_id and the reason of session end
    def to_s
      "Session Ended for requestID: #{request_id} with reason #{reason}"
    end
  end
end
