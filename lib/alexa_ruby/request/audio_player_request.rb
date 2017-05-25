module AlexaRuby
  # AudioPlayerRequest class implements Alexa "AudioPlayer" request type
  class AudioPlayerRequest < Request
    attr_accessor :playback_state, :playback_offset, :error_type,
                  :error_message, :error_playback_token, :error_player_activity

    # Initialize new AudioPlayer request
    #
    # @param json [Hash] valid JSON request from Amazon
    def initialize(json)
      @type = :audio_player
      req = json[:request]
      @playback_state = req[:type].gsub!('AudioPlayer.', '')
      @playback_offset = current_offset(req)
      define_error_params(req) if @playback_state == 'PlaybackFailed'
      super
    end

    # Outputs the launch requestID
    #
    # @return [String] launch request ID
    def to_s
      "AudioPlayerRequest requestID: #{request_id}"
    end

    private

    # Get current playback offset from request
    #
    # @param json [Hash] "request" part of json request from Amazon
    # @return [Integer] playback offset in milliseconds at the moment of request
    def current_offset(json)
      if @playback_state == 'PlaybackFailed'
        json[:currentPlaybackState][:offsetInMilliseconds]
      else
        json[:offsetInMilliseconds]
      end
    end

    # Define all error parameters if an error occured during playback
    #
    # @param json [Hash] "request" part of json request from Amazon
    def define_error_params(json)
      @error_type = json[:error][:type]
      @error_message = json[:error][:message]
      @error_playback_token = json[:currentPlaybackState][:token]
      @error_player_activity = json[:currentPlaybackState][:playerActivity]
    end
  end
end
