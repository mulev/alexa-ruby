require 'alexa_ruby/response/audio_player'
require 'alexa_ruby/response/card'

module AlexaRuby
  # Class implements response for Amazon Alexa API
  class Response
    attr_accessor :version, :session, :response_object, :session_attributes,
                  :speech, :reprompt, :response, :card

    # Initialize new response and set response version
    #
    # @param version [String] response version
    def initialize(version = '1.0')
      @session_attributes = {}
      @version = version
      @directives = []
    end

    # Adds a key => value pair to the session object
    #
    # @param key [String] attribute key
    # @param value [String] attribute value
    def add_session_attribute(key, value)
      @session_attributes[key.to_sym] = value
    end

    # Add output speech to response object.
    # Speech can be plain text or SSML text, default type is plain text
    #
    # @param speech_text [String] output speech
    # @param ssml [Boolean] is it an SSML speech or not
    def add_speech(speech_text, ssml = false)
      @speech =
        if ssml
          { type: 'SSML', ssml: check_ssml(speech_text) }
        else
          { type: 'PlainText', text: speech_text }
        end
      @speech
    end

    # Add AudioPlayer directive
    #
    # @param directive [String] audio player directive type,
    #                           can be :start or :stop
    # @param opts [Hash] optional request parameters
    def add_audio_player_directive(directive, opts = {})
      player = AudioPlayer.new
      @directives = []
      case directive.to_sym
      when :start
        player.build_play_directive(opts)
      when :stop
        player.build_stop_directive
      end
      @directives << player.directive
    end

    # Add reprompt to outputSpeech node
    #
    # @param speech_text [String] output speech
    # @param ssml [Boolean] is it an SSML speech or not
    def add_reprompt(speech_text, ssml = false)
      @reprompt =
        if ssml
          { outputSpeech: { type: 'SSML', ssml: check_ssml(speech_text) } }
        else
          { outputSpeech: { type: 'PlainText', text: speech_text } }
        end
      @reprompt
    end

    # Add card that will be shown in Amazon Alexa app on user smartphone/tablet
    #
    # @param opts [Hash] hash with card parameters
    # @return [Hash] card object
    def add_card(opts = {})
      opts[:type] = 'Simple' if opts[:type].nil?
      card = Card.new
      card.build(opts)
      @card = card.obj
    end

    # Adds a speech to the object, also returns a outputspeech object
    #
    # @param speech [String] output speech
    # @param end_session [Boolean] is it a final response, or not
    # @param ssml [Boolean] is it an SSML speech or not
    def say_response(speech, end_session = true, ssml = false)
      output_speech = add_speech(speech, ssml)
      { outputSpeech: output_speech, shouldEndSession: end_session }
    end

    # Incorporates reprompt in the SDK 2015-05
    #
    # @param speech [String] output speech
    # @param reprompt_speech [String] output repromt speech
    # @param end_session [Boolean] is it a final response, or not
    # @param speech_ssml [Boolean] is it an SSML speech or not
    # @param reprompt_ssml [Boolean] is it an SSML repromt speech or not
    def say_response_with_reprompt(speech, reprompt_speech, end_session = true,
                                   speech_ssml = false, reprompt_ssml = false)
      output_speech = add_speech(speech, speech_ssml)
      reprompt_speech = add_reprompt(reprompt_speech, reprompt_ssml)
      {
        outputSpeech: output_speech,
        reprompt: reprompt_speech,
        shouldEndSession: end_session
      }
    end

    # Creates a session object. We pretty much only use this in testing.
    # If it's empty assume user doesn't need session attributes
    #
    # @return [Hash] user session parameters
    def build_session
      @session_attributes = {} if @session_attributes.nil?
      @session = { sessionAttributes: @session_attributes }
      @session
    end

    # The response object (with outputspeech, cards and session end)
    # Should rename this, but Amazon picked their names.
    # The only mandatory field is end_session which we default to true.
    #
    # @param session_end [Boolean] is it a final response, or not
    # @return [Hash] response parameters
    def build_response_object(session_end = true)
      @response = {}
      @response[:outputSpeech] = @speech unless @speech.nil?
      @response[:directives] = @directives unless @directives.empty?
      @response[:card] = @card unless @card.nil?
      @response[:reprompt] = @reprompt unless session_end && @reprompt.nil?
      @response[:shouldEndSession] = session_end
      @response
    end

    # Builds a response.
    # Takes the version, response, should_end_session variables
    # and builds a JSON object
    #
    # @param session_end [Boolean] is it a final response, or not
    # @return [JSON] json response for Amazon Alexa
    def build_response(session_end = true)
      response_object = build_response_object(session_end)
      response = {}
      response[:version] = @version
      unless @session_attributes.empty?
        response[:sessionAttributes] = @session_attributes
      end
      response[:response] = response_object
      Oj.to_json(response)
    end

    # Outputs the version, session object and the response object.
    #
    # @return [String] version, session object and the response object
    def to_s
      "Version => #{@version}, SessionObj => #{@session}, " \
        "Response => #{@response}"
    end

    private

    # Check and fix SSML speech
    #
    # @param ssml [String] SSML string
    # @return [String] valid SSML string
    def check_ssml(ssml)
      open_tag = ssml.strip[0..6]
      close_tag = ssml.strip[-8..1]
      ssml = open_tag == '<speak>' ? ssml : "<speak>#{ssml}"
      close_tag == '</speak>' ? ssml : "#{ssml}</speak>"
    end
  end
end
