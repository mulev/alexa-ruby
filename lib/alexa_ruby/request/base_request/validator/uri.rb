module AlexaRuby
  # URI request validator
  class URI
    attr_reader :uri

    # Setup new URI
    #
    # @param uri [String] URI
    def initialize(uri)
      @uri = Addressable::URI.parse(uri).normalize!
    end

    # Check if it is a valid Amazon URI
    #
    # @return [Boolean]
    def valid?
      raise ArgumentError, 'Certificates chain URL must be HTTPS' unless https?
      raise ArgumentError, 'Not Amazon host in certificates URL' unless amazon?
      raise ArgumentError, 'Invalid certificates chain URL' unless echo_api?
      raise ArgumentError, 'Certificates chain URL must be HTTPS' unless port?
      true
    end

    private

    # Check if URI scheme is HTTPS
    #
    # @return [Boolean]
    def https?
      @uri.scheme == 'https'
    end

    # Check if URI host is a valid Amazon host
    #
    # @return [Boolean]
    def amazon?
      @uri.host.casecmp('s3.amazonaws.com').zero?
    end

    # Check if URI path starts with /echo.api/
    #
    # @return [Boolean]
    def echo_api?
      @uri.path[0..9] == '/echo.api/'
    end

    # Check if URI port is 443 if port is present
    #
    # @return [Boolean]
    def port?
      @uri.port.nil? || @uri.port == 443
    end
  end
end
