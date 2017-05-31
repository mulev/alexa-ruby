require_relative 'spec_helper'

describe 'Amazon Alexa request handling' do
  before do
    @fpath = 'spec/fixtures/request'
  end

  describe 'General request handling' do
    before do
      @json = File.read("#{@fpath}/launch_request.json")
    end

    describe 'Request' do
      it 'should build a Request object for valid JSON' do
        alexa = AlexaRuby.new(@json)
        alexa.request.wont_be_nil
      end

      it 'should build a Response object for valid JSON' do
        alexa = AlexaRuby.new(@json)
        alexa.response.wont_be_nil
      end

      it 'should build a Request object for valid Hash' do
        alexa = AlexaRuby.new(Oj.load(@json))
        alexa.request.wont_be_nil
      end

      it 'should build a Response object for valid Hash' do
        alexa = AlexaRuby.new(Oj.load(@json))
        alexa.response.wont_be_nil
      end

      it 'should raise ArgumentError in case of invalid JSON' do
        err = proc { AlexaRuby.new('{"test":}') }.must_raise ArgumentError
        err.message.must_equal 'Request must be a valid JSON object'
      end

      it 'should raise ArgumentError in case of invalid Hash' do
        err = proc { AlexaRuby.new('{"test":}') }.must_raise ArgumentError
        err.message.must_equal 'Request must be a valid JSON object'
      end

      it 'should setup all request parameters' do
        alexa = AlexaRuby.new(@json)
        alexa.request.version.wont_be_nil
        alexa.request.type.wont_be_nil
        alexa.request.context.wont_be_nil
        alexa.request.id.wont_be_nil
        alexa.request.timestamp.wont_be_nil
        alexa.request.locale.wont_be_nil
      end

      it 'should raise ArgumentError if request ID is missing' do
        req = Oj.load(@json, symbol_keys: true)
        req[:request][:requestId] = nil
        err = proc { AlexaRuby.new(req) }.must_raise ArgumentError
        err.message.must_equal 'Missing request ID'
      end

      it 'should raise ArgumentError if request timestamp is missing' do
        req = Oj.load(@json, symbol_keys: true)
        req[:request][:timestamp] = nil
        err = proc { AlexaRuby.new(req) }.must_raise ArgumentError
        err.message.must_equal 'Missing request timestamp'
      end

      it 'should raise ArgumentError if request type unknown' do
        req = Oj.load(@json, symbol_keys: true)
        req[:request][:type] = 'dummy'
        err = proc { AlexaRuby.new(req) }.must_raise ArgumentError
        err.message.must_equal 'Unknown type of Alexa request'
      end

      it 'should raise ArgumentError if request structure isn\'t valid' do
        req = Oj.load(@json, symbol_keys: true)
        req[:request] = nil
        msg = 'Invalid request structure, ' \
              'please, refer to the Amazon Alexa manual: ' \
              'https://developer.amazon.com/public/solutions' \
              '/alexa/alexa-skills-kit/docs/alexa-skills-kit-interface-reference'
        err = proc { AlexaRuby.new(req) }.must_raise ArgumentError
        err.message.must_equal msg
      end
    end

    describe 'Session' do
      it 'should set correct session params' do
        alexa = AlexaRuby.new(@json)
        alexa.request.session.state.wont_be_nil
        alexa.request.session.id.wont_be_nil
      end

      it 'should raise ArgumentError if session isn\'t valid' do
        req = Oj.load(@json, symbol_keys: true)
        req[:session] = nil
        err = proc { AlexaRuby.new(req) }.must_raise ArgumentError
        err.message.must_equal 'Empty user session'
      end
    end

    describe 'Context' do
      it 'should set correct context params' do
        alexa = AlexaRuby.new(@json)
        alexa.request.context.app_id.wont_be_nil
        alexa.request.context.user.wont_be_nil
        alexa.request.context.user.id.wont_be_nil
        alexa.request.context.device.wont_be_nil
        alexa.request.context.device.id.wont_be_nil
      end

      it 'should raise ArgumentError if application ID is missing' do
        req = Oj.load(@json, symbol_keys: true)
        req[:context][:System][:application][:applicationId] = nil
        err = proc { AlexaRuby.new(req) }.must_raise ArgumentError
        err.message.must_equal 'Missing application ID'
      end

      it 'should raise ArgumentError if user ID is missing' do
        req = Oj.load(@json, symbol_keys: true)
        req[:context][:System][:user][:userId] = nil
        err = proc { AlexaRuby.new(req) }.must_raise ArgumentError
        err.message.must_equal 'Missing user ID'
      end

      it 'should raise ArgumentError if device ID is missing' do
        req = Oj.load(@json, symbol_keys: true)
        req[:context][:System][:device][:deviceId] = nil
        err = proc { AlexaRuby.new(req) }.must_raise ArgumentError
        err.message.must_equal 'Missing device ID'
      end
    end
  end

  describe 'LaunchRequest' do
    before do
      @json = File.read("#{@fpath}/launch_request.json")
    end

    it 'should parse valid LaunchRequest correctly' do
      alexa = AlexaRuby.new(@json)
      alexa.request.type.must_equal :launch
    end
  end

  describe 'IntentRequest' do
    before do
      @json = File.read("#{@fpath}/intent_request.json")
    end

    it 'should parse valid IntentRequest correctly' do
      alexa = AlexaRuby.new(@json)
      alexa.request.type.must_equal :intent
      alexa.request.intent_name.must_equal 'GetZodiacHoroscopeIntent'
      alexa.request.confirmation_status.must_equal :unknown
      alexa.request.dialog_state.must_equal :completed
      alexa.request.slots[0].name.must_equal 'ZodiacSign'
    end

    it 'should raise an ArgumentError if intent is undefined' do
      req = Oj.load(@json, symbol_keys: true)
      req[:request][:intent] = nil
      err = proc { AlexaRuby.new(req) }.must_raise ArgumentError
      err.message.must_equal 'Intent must be defined'
    end
  end

  describe 'SessionEndedRequest' do
    before do
      @json = File.read("#{@fpath}/session_ended_request.json")
    end

    it 'should parse valid SessionEndedRequest correctly' do
      alexa = AlexaRuby.new(@json)
      alexa.request.type.must_equal :session_ended
      alexa.request.session.state.must_equal :ended
      alexa.request.session.end_reason.must_equal :user_quit
    end
  end

  describe 'AudioPlayerRequest' do
    before do
      @json = File.read("#{@fpath}/audio_player_request.json")
    end

    it 'should parse valid AudioPlayerRequest correctly' do
      alexa = AlexaRuby.new(@json)
      alexa.request.type.must_equal :audio_player
      alexa.request.playback_state.must_equal 'PlaybackFailed'
      alexa.request.playback_offset.must_equal 0
      alexa.request.error_type.must_equal 'string'
      alexa.request.error_message.must_equal 'string'
      alexa.request.error_playback_token.must_equal 'string'
      alexa.request.error_player_activity.must_equal 'string'
    end
  end
end
