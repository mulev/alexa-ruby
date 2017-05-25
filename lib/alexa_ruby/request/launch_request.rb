module AlexaRuby
  # LaunchRequest class implements Alexa "LaunchRequest" request type
  class LaunchRequest < Request
    # Initialize new launch request
    #
    # @param json [JSON] valid JSON request from Amazon
    def initialize(json)
      @type = :launch
      super
    end

    # Outputs the launch requestID
    #
    # @return [String] launch request ID
    def to_s
      "LaunchRequest requestID: #{request_id}"
    end
  end
end
