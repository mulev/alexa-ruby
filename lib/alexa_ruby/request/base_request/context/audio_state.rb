module AlexaRuby
  # Audio state from context section in request
  class AudioState
    attr_reader :token, :playback_offset, :playback_state

    # Setup new AudioState object
    #
    # @param audio_state [Hash] audio player state
    def initialize(audio_state)
      @token = audio_state[:token]
      @playback_offset = audio_state[:offsetInMilliseconds]
      @playback_state = audio_state[:playerActivity]
    end
  end
end
