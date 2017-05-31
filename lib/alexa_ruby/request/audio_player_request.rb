module AlexaRuby
  # Alexa "AudioPlayer" and "PlaybackController" request type
  class AudioPlayerRequest < BaseRequest
    attr_reader :playback_state, :playback_offset, :error_type,
                :error_message, :error_playback_token, :error_player_activity

    # Initialize new AudioPlayer request
    #
    # @param request [Hash] valid request from Amazon Alexa service
    def initialize(request)
      @type = :audio_player
      super
      req = @req[:request]
      @playback_state = req[:type].gsub!('AudioPlayer.', '')
      @playback_offset = current_offset(req)
      define_error_params(req) if @playback_state == 'PlaybackFailed'
    end

    private

    # Get current playback offset from request
    #
    # @param request [Hash] valid request from Amazon Alexa service
    # @return [Integer] playback offset in milliseconds at the moment of request
    def current_offset(request)
      if @playback_state == 'PlaybackFailed'
        request[:currentPlaybackState][:offsetInMilliseconds]
      else
        request[:offsetInMilliseconds]
      end
    end

    # Define all error parameters if an error occured during playback
    #
    # @param request [Hash] valid request from Amazon Alexa service
    def define_error_params(request)
      @error_type = request[:error][:type]
      @error_message = request[:error][:message]
      @error_playback_token = request[:currentPlaybackState][:token]
      @error_player_activity = request[:currentPlaybackState][:playerActivity]
    end
  end
end
