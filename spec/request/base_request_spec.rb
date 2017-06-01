require_relative '../spec_helper'

describe 'AlexaRuby' do
  before do
    @fpath = 'spec/fixtures/request'
  end

  describe 'BaseRequest' do
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

      it 'should return received request in JSON format' do
        alexa = AlexaRuby.new(@json)
        sample = Oj.to_json(Oj.load(@json))
        alexa.request.json.must_equal sample
      end
    end
  end
end
