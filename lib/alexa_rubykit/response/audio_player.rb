module AlexaRubykit
  # AudioPlayer class encapsulates all Alexa audio player directives
  class AudioPlayer
    # Build an AudioPlayer.Play directive
    #
    # @param url [String] audio stream URL
    # @param token [String] some token that represents the audio stream
    # @param offset [Integer] the timestamp in the stream from which Alexa should begin playback
    # @return [Hash] AudioPlayer.Play directive
    def play_directive(url, token, offset)
      {
        type: 'AudioPlayer.Play',
        playBehavior: 'REPLACE_ALL',
        audioItem: {
          stream: {
            token: token,
            url: url,
            offsetInMilliseconds: offset
          }
        }
      }
    end

    # Build AudioPlayer.Stop directive
    #
    # @return [Hash] AudioPlayer.Stop directive
    def stop_directive
      {
        type: 'AudioPlayer.Stop'
      }
    end
  end
end
