require 'time'

module AlexaRuby
  # Validator is responsible for Amazon request validation:
  #   - SignatureCertChainUrl validation
  #   - Amazon Alexa request signature validation
  class Validator
    TIMESTAMP_TOLERANCE = 150

    # Setup new validator
    #
    # @param cert_chain_url [String] SSL certificates chain URI
    # @param signature [String] HTTP request signature
    # @param request [Object] json request
    # @param timestamp_diff [Integer] valid distance in seconds between
    #                                 current time and the request timestamp
    def initialize(cert_chain_url, signature, request, timestamp_diff = nil)
      @chain_url = cert_chain_url
      @signature = signature
      @request = request
      @timestamp_diff = timestamp_diff || TIMESTAMP_TOLERANCE
    end

    # Check if it is a valid Amazon request
    #
    # @return [Boolean]
    def valid_request?
      unless timestamp_tolerant?
        raise ArgumentError,
              'Outdated request: request timestamp is more than ' \
              "#{@timestamp_diff} seconds later than current time"
      end
      valid_uri? && valid_certificates?
    end

    private

    # Check if request is timestamp tolerant
    #
    # @return [Boolean]
    def timestamp_tolerant?
      request_ts = @request[:request][:timestamp]
      Time.parse(request_ts) >= (Time.now - @timestamp_diff)
    end

    # Check if it is a valid Amazon URI
    #
    # @return [Boolean]
    def valid_uri?
      URI.new(@chain_url).valid?
    end

    # Check if it is a valid certificates chain and request signature
    #
    # @return [Boolean]
    def valid_certificates?
      Certificates.new(@chain_url, @signature, JSON.generate(@request)).valid?
    end
  end
end
