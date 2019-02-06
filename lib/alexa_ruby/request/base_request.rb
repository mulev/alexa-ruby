module AlexaRuby
  # Amazon Alexa web service request
  class BaseRequest
    attr_reader :version, :type, :session, :context, :id, :timestamp, :locale
    attr_accessor :certificates_chain_url, :signature

    # Initialize new request object
    #
    # @param request [Hash] request from Amazon Alexa web service
    def initialize(request)
      @req = request
      @version = @req[:version]
      @session = parse_session unless @type == :audio_player
      @context = parse_context unless @req[:context].nil?
      @id = nil
      @timestamp = nil
      @locale = nil
      parse_base_params(@req[:request])
    end

    # Check if it is a valid Amazon request
    #
    # @return [Boolean]
    def valid?
      validator = Validator.new(certificates_chain_url, signature, @req)
      validator.valid_request?
    end

    # Return JSON representation of given request
    #
    # @return [String] request json
    def json
      JSON.generate(@req)
    end

    private

    # Build session object
    def parse_session
      Session.new(@req[:session])
    end

    # Build a request context object
    #
    # @return [Object] new Context object instance
    def parse_context
      Context.new(@req[:context])
    end

    # Set request parameters
    #
    # @param req [Hash] request parameters
    # @raise [ArgumentError] if missing ID or timestamp
    def parse_base_params(req)
      @id = req[:requestId] unless req[:requestId].nil?
      raise ArgumentError, 'Missing request ID' unless @id
      @timestamp = DateTime.parse(req[:timestamp]) unless req[:timestamp].nil?
      raise ArgumentError, 'Missing request timestamp' unless @timestamp
      @locale = req[:locale] unless req[:locale].nil?
    end
  end
end
