module AlexaRuby
  # Response for Amazon Alexa service request
  class Response
    # Initialize new response
    #
    # @param request_type [Symbol] AlexaRuby::Request type
    # @param version [String] Amazon Alexa SDK version
    def initialize(request_type, version = '1.0')
      @req_type = request_type
      @resp = {
        version: version,
        sessionAttributes: {},
        response: { shouldEndSession: true }
      }
    end

    # Add one session attribute
    #
    # @param key [String] atrribute key
    # @param value [String] attribute value
    # @param rewrite [Boolean] rewrite if key already exists?
    # @raise [ArgumentError] if session key is already added and
    #   rewrite is set to false
    def add_session_attribute(key, value, rewrite = false)
      session_attribute(key, value, rewrite)
    end

    # Add pack of session attributes and overwrite all existing ones
    #
    # @param attributes [Hash] pack of session attributes
    # @raise [ArgumentError] if given paramter is not a Hash object
    def add_session_attributes(attributes)
      unless attributes.is_a? Hash
        raise ArgumentError, 'Attributes must be a Hash'
      end
      session_attributes(attributes, false)
    end

    # Add pack of session attributes to existing ones
    #
    # @param attributes [Hash] pack of session attributes
    # @raise [ArgumentError] if given paramter is not a Hash object
    def merge_session_attributes(attributes)
      unless attributes.is_a? Hash
        raise ArgumentError, 'Attributes must be a Hash'
      end
      session_attributes(attributes, true)
    end

    # Add card to response object
    #
    # @param params [Hash] card parameters:
    #   type [String] card type, can be "Simple", "Standard" or "LinkAccount"
    #   title [String] card title
    #   content [String] card content (line breaks must be already included)
    #   small_image_url [String] an URL for small card image
    #   large_image_url [String] an URL for large card image
    # @raise [ArgumentError] if card is not allowed
    def add_card(params = {})
      card_exception unless %i[launch intent].include? @req_type
      card = Card.new(params)
      @resp[:response][:card] = card.obj
    end

    # Add AudioPlayer directive
    #
    # @param directive [String] audio player directive type,
    #                           can be :start or :stop
    # @param params [Hash] optional request parameters:
    #   url [String] streaming URL
    #   token [String] streaming service token
    #   offset [Integer] playback offset
    #   replace_all [Boolean] true if stream must replace all previous
    def add_audio_player_directive(directive, params = {})
      @resp[:response][:directives] = [
        case directive.to_sym
        when :start
          AudioPlayer.new.play(params)
        when :stop
          AudioPlayer.new.stop
        when :clear
          AudioPlayer.new.clear_queue(params[:clear_behavior])
        end
      ]
    end

    # Return JSON version of current response state
    #
    # @return [JSON] response object
    def json
      JSON.generate(@resp)
    end

    # Tell something to Alexa user and close conversation.
    # Method will only add a given speech to response object
    #
    # @param speech [Sring] output speech
    # @param reprompt_speech [String] output speech if user remains idle
    # @param ssml [Boolean] is it an SSML speech or not
    def tell(speech, reprompt_speech = nil, ssml = false)
      obj = { outputSpeech: build_speech(speech, ssml) }
      if reprompt_speech
        obj[:reprompt] = { outputSpeech: build_speech(reprompt_speech, ssml) }
      end
      @resp[:response].merge!(obj)
    end

    # Tell something to Alexa user and close conversation.
    # Method will add given sppech to response object and
    # immediately return its JSON implementation
    #
    # @param speech [Sring] output speech
    # @param reprompt_speech [String] output speech if user remains idle
    # @param ssml [Boolean] is it an SSML speech or not
    # @return [JSON] ready to use response object
    def tell!(speech, reprompt_speech = nil, ssml = false)
      obj = { outputSpeech: build_speech(speech, ssml) }
      if reprompt_speech
        obj[:reprompt] = { outputSpeech: build_speech(reprompt_speech, ssml) }
      end
      @resp[:response].merge!(obj)
      json
    end

    # Ask something from user and wait for further information.
    # Method will only add given sppech to response object and
    # set "shouldEndSession" parameter to false
    #
    # @param speech [Sring] output speech
    # @param reprompt_speech [String] output speech if user remains idle
    # @param ssml [Boolean] is it an SSML speech or not
    def ask(speech, reprompt_speech = nil, ssml = false)
      @resp[:response][:shouldEndSession] = false
      tell(speech, reprompt_speech, ssml)
    end

    # Ask something from user and wait for further information.
    # Method will only add given sppech to response object,
    # set "shouldEndSession" parameter to false and
    # immediately return response JSON implementation
    #
    # @param speech [Sring] output speech
    # @param reprompt_speech [String] output speech if user remains idle
    # @param ssml [Boolean] is it an SSML speech or not
    # @return [JSON] ready to use response object
    def ask!(speech, reprompt_speech = nil, ssml = false)
      @resp[:response][:shouldEndSession] = false
      tell!(speech, reprompt_speech, ssml)
    end

    private

    # Add one session attribute
    #
    # @param key [String] atrribute key
    # @param value [String] attribute value
    # @param rewrite [Boolean] rewrite if key already exists?
    # @raise [ArgumentError] if session key is already added and
    #   rewrite is set to false
    def session_attribute(key, value, rewrite = false)
      unless rewrite
        if @resp[:sessionAttributes].key?(key)
          raise ArgumentError, 'Duplicate session attributes not allowed'
        end
      end
      @resp[:sessionAttributes][key] = value
    end

    # Add pack of session attributes.
    # By default all existing session attributes would be overwritten
    #
    # @param attributes [Hash] pack of session attributes
    # @param merge [Boolean] merge attributes with existing ones?
    def session_attributes(attributes, merge)
      rewrite = true
      unless merge
        @resp[:sessionAttributes] = {}
        rewrite = false
      end
      attributes.each { |k, v| session_attribute(k, v, rewrite) }
    end

    # Build speech object
    #
    # @param speech [Sring] output speech
    # @param ssml [Boolean] is it an SSML speech or not
    # @return [Hash] speech object
    def build_speech(speech, ssml)
      obj = { type: ssml ? 'SSML' : 'PlainText' }
      ssml ? obj[:ssml] = fix_ssml(speech) : obj[:text] = speech
      obj
    end

    # Forced fix of SSML speech - manually check and fix open and close tags
    #
    # @param text [String] SSML response speech
    # @return [String] fixed SSML speech
    def fix_ssml(text)
      open_tag = text.strip[0..6]
      close_tag = text.strip[-8..1]
      text = open_tag == '<speak>' ? text : "<speak>#{text}"
      close_tag == '</speak>' ? text : "#{text}</speak>"
    end

    # Raise card exception
    #
    # @raise [ArgumentError] if card is not allowed
    def card_exception
      raise ArgumentError, 'Card can only be included in response ' \
                            'to a "LaunchRequest" or "IntentRequest"'
    end
  end
end
