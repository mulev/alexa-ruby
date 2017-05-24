module AlexaRuby
  # AudioPlayerRequest class implements Alexa "AudioPlayer" request type
  class AudioPlayerRequest < Request
    # Initialize new AudioPlayer request
    #
    # @param json [JSON] valid JSON request from Amazon
    def initialize(json)
      @type = :audio_player
      super
    end

    # Outputs the launch requestID
    #
    # @return [String] launch request ID
    def to_s
      "AudioPlayerRequest requestID: #{request_id}"
    end
  end
end
