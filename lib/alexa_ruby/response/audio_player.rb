module AlexaRuby
  # AudioPlayer class encapsulates all Alexa audio player directives
  class AudioPlayer
    # Build an AudioPlayer.Play directive
    #
    # @param params [Hash] optional request parameters:
    #   url [String] streaming URL
    #   token [String] streaming service token
    #   offset [Integer] playback offset
    # @return [Hash] AudioPlayer.Play directive
    # @raise [ArgumentError] if audio URL isn't valid
    def play_directive(params)
      url = params[:url]
      if invalid_url?(url)
        raise ArgumentError, 'Audio URL must be a valid ' \
                              'SSL-enabled (HTTPS) endpoint'
      end
      token = token(params[:token])
      offset = params[:offset] || 0
      build_directive('AudioPlayer.Play', url, token, offset)
    end

    # Build AudioPlayer.Stop directive
    #
    # @return [Hash] AudioPlayer.Stop directive
    def stop_directive
      build_directive('AudioPlayer.Stop')
    end

    private

    # Set play directive parameters
    #
    # @param type [String] directive type, can be Play or Stop
    # @param url [String] streaming service URL
    # @param token [String] streaming service token
    # @param offset [Integer] playback offset
    def build_directive(type, url = nil, token = nil, offset = nil)
      directive = { type: type }
      return directive if type == 'AudioPlayer.Stop'
      directive[:playBehavior] = 'REPLACE_ALL'
      directive[:audioItem] = { stream: {} }
      directive[:audioItem][:stream][:url] = url
      directive[:audioItem][:stream][:token] = token
      directive[:audioItem][:stream][:offsetInMilliseconds] = offset
      directive
    end

    # Check if given URL isn't an SSL-enabled endpoint
    #
    # @param url [String] some URL
    # @return [Boolean]
    def invalid_url?(url)
      URI.parse(url).scheme != 'https'
    end

    # Get station token
    #
    # @param token [String] station token
    # @return [Boolean]
    def token(token)
      token.nil? || token.empty? ? SecureRandom.uuid : token
    end
  end
end
