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
      https? && amazon? && echo_api? && port?
    end

    private

    # Check if URI scheme is HTTPS
    #
    # @return [Boolean]
    def https?
      @uri.scheme == 'https' ||
        raise(
          ArgumentError,
          'Certificates chain URL must be an HTTPS-enabled endpoint ' \
          "(current endpoint: #{@uri})"
        )
    end

    # Check if URI host is a valid Amazon host
    #
    # @return [Boolean]
    def amazon?
      @uri.host.casecmp('s3.amazonaws.com').zero? ||
        raise(
          ArgumentError,
          'Certificates chain host must be equal to "s3.amazonaws.com" ' \
          "(current host: #{@uri.host})"
        )
    end

    # Check if URI path starts with /echo.api/
    #
    # @return [Boolean]
    def echo_api?
      @uri.path[0..9] == '/echo.api/' ||
        raise(
          ArgumentError,
          'Certificates chain URL path must start with "/echo.api/" ' \
          "(current path: #{@uri.path})"
        )
    end

    # Check if URI port is 443 if port is present
    #
    # @return [Boolean]
    def port?
      @uri.port.nil? || @uri.port == 443 ||
        raise(
          ArgumentError,
          'If certificates chain URL has a port specified, it must be 443 ' \
          "(current port: #{@uri.port})"
        )
    end
  end
end
