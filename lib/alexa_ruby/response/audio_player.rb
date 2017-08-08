module AlexaRuby
  # AudioPlayer class encapsulates all Alexa audio player directives
  class AudioPlayer
    # Build an AudioPlayer.Play directive
    #
    # @param params [Hash] optional request parameters:
    #   behavior [Symbol] playback behavior
    #   url [String] streaming URL
    #   token [String] streaming service token
    #   previous_token [String] previous played audio token
    #   offset [Integer] playback offset
    # @return [Hash] AudioPlayer.Play directive
    # @raise [ArgumentError] if audio URL isn't valid
    def play(params)
      @opts = params
      if invalid_url?(@opts[:url])
        raise ArgumentError, 'Audio URL must be a valid ' \
                              'SSL-enabled (HTTPS) endpoint'
      end
      play_directive
    end

    # Build AudioPlayer.Stop directive
    #
    # @return [Hash] AudioPlayer.Stop directive
    def stop
      { type: 'AudioPlayer.Stop' }
    end

    # Build AudioPlayer.ClearQueue directive
    #
    # @param behavior [Symbol] clearing behavior
    # @return [Hash] AudioPlayer.ClearQueue directive
    def clear_queue(behavior = :clear_all)
      clear_behavior =
        case behavior
        when :clear_all
          'CLEAR_ALL'
        when :clear_queue
          'CLEAR_ENQUEUED'
        else
          'CLEAR_ALL'
        end
      { type: 'AudioPlayer.ClearQueue', clearBehavior: clear_behavior }
    end

    private

    # Define playback behavior
    #
    # @param behavior [Symbol] playback behavior
    # @return [String] Amazon behavior type
    def playback_behavior(behavior)
      case behavior
      when :replace_all
        'REPLACE_ALL'
      when :enqueue
        'ENQUEUE'
      when :replace_enqueued
        'REPLACE_ENQUEUED'
      else
        'REPLACE_ALL'
      end
    end

    # Build play directive
    #
    # @return [Hash] ready to use AudioPlayer.Play directive
    def play_directive
      directive = { type: 'AudioPlayer.Play' }
      directive[:playBehavior] = playback_behavior(@opts[:play_behavior])
      directive[:audioItem] = { stream: { url: @opts[:url] } }
      stream = directive[:audioItem][:stream]
      stream[:token] = token(@opts[:token])
      stream[:offsetInMilliseconds] = @opts[:offset] || 0
      if directive[:playBehavior] == 'ENQUEUE'
        stream[:expectedPreviousToken] = @opts[:previous_token] || ''
      end
      directive
    end

    # Check if given URL isn't an SSL-enabled endpoint
    #
    # @param url [String] some URL
    # @return [Boolean]
    def invalid_url?(url)
      Addressable::URI.parse(url).scheme != 'https'
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
