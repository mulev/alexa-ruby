module AlexaRuby
  # LaunchRequest class implements Alexa "LaunchRequest" request type
  class LaunchRequest < BaseRequest
    # Initialize new launch request
    #
    # @param request [Hash] valid request from Amazon Alexa service
    def initialize(request)
      @type = :launch
      super
    end
  end
end
