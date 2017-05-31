require_relative 'spec_helper'

describe 'Build response to Amazon Alexa service' do
  before do
    @req_path = 'spec/fixtures/request'
    @resp_path = 'spec/fixtures/response'
  end

  describe 'General response handling' do
    before do
      @json = File.read("#{@req_path}/launch_request.json")
      @alexa = AlexaRuby.new(@json)
    end

    it 'should build a Response object for valid JSON' do
      @alexa.response.wont_be_nil
      resp = Oj.load(@alexa.response.json, symbol_keys: true)
      resp[:version].wont_be_nil
      resp[:response][:shouldEndSession].must_equal true
    end
  end

  describe 'Session parameters management' do
    before do
      @json = File.read("#{@req_path}/launch_request.json")
      @alexa = AlexaRuby.new(@json)
    end

    it 'should add one session attribute correctly' do
      @alexa.response.add_session_attribute(:id, 'djsdhdsjhdsjhdsjh')
      resp = Oj.load(@alexa.response.json, symbol_keys: true)
      resp[:sessionAttributes][:id].must_equal 'djsdhdsjhdsjhdsjh'
    end

    it 'should add pack of session attributes correctly' do
      @alexa.response.add_session_attributes(
        id: 'djsdhdsjhdsjhdsjh',
        test: 'test'
      )
      resp = Oj.load(@alexa.response.json, symbol_keys: true)
      resp[:sessionAttributes][:id].must_equal 'djsdhdsjhdsjhdsjh'
      resp[:sessionAttributes][:test].must_equal 'test'
    end

    it 'should merge pack of session attributes correctly' do
      @alexa.response.add_session_attributes(
        id: 'djsdhdsjhdsjhdsjh',
        test: 'test'
      )
      @alexa.response.merge_session_attributes(token: '7783y3h43hg4ghh')
      resp = Oj.load(@alexa.response.json, symbol_keys: true)
      resp[:sessionAttributes][:id].must_equal 'djsdhdsjhdsjhdsjh'
      resp[:sessionAttributes][:test].must_equal 'test'
      resp[:sessionAttributes][:token].must_equal '7783y3h43hg4ghh'
    end

    it 'should raise ArgumentError if duplicate attribute found' do
      @alexa.response.add_session_attribute(:id, 'djsdhdsjhdsjhdsjh')
      err = proc {
        @alexa.response.add_session_attribute(:id, '833hj33jh3hj')
      }.must_raise ArgumentError
      err.message.must_equal 'Duplicate session attributes not allowed'
    end

    it 'should raise ArgumentError if attributes pack isn\'t a Hash' do
      err = proc {
        @alexa.response.add_session_attributes('Test')
      }.must_raise ArgumentError
      err.message.must_equal 'Attributes must be a Hash'
    end
  end

  describe 'Cards management' do
    before do
      @json = File.read("#{@req_path}/launch_request.json")
      @card = Oj.load(
        File.read("#{@resp_path}/sample_card.json"),
        symbol_keys: true
      )
      @alexa = AlexaRuby.new(@json)
    end

    it 'should add card to response' do
      @alexa.response.add_card(@card)
      resp = Oj.load(@alexa.response.json, symbol_keys: true)
      resp[:response][:card][:type].must_equal 'Simple'
      resp[:response][:card][:title].must_equal 'title'
      resp[:response][:card][:content].must_equal 'text'
    end

    it 'should add "text" and "image" nodes if card type is Standard' do
      @card[:type] = 'Standard'
      @alexa.response.add_card(@card)
      resp = Oj.load(@alexa.response.json, symbol_keys: true)
      small_url = 'https://test.ru/example_small.jpg'
      large_url = 'https://test.ru/example_large.jpg'
      resp[:response][:card][:type].must_equal 'Standard'
      resp[:response][:card][:text].must_equal 'text'
      resp[:response][:card][:image][:smallImageUrl].must_equal small_url
      resp[:response][:card][:image][:largeImageUrl].must_equal large_url
    end

    it 'should raise ArgumentError if no title given' do
      @card[:title] = nil
      err = proc { @alexa.response.add_card(@card) }.must_raise ArgumentError
      err.message.must_equal 'Card need a title'
    end

    it 'should raise ArgumentError if card type unknown' do
      @card[:type] = 'Test'
      err = proc { @alexa.response.add_card(@card) }.must_raise ArgumentError
      err.message.must_equal 'Unknown card type'
    end
  end

  describe 'Audio directives management' do
    before do
      @json = File.read("#{@req_path}/launch_request.json")
      @audio = Oj.load(
        File.read("#{@resp_path}/sample_audio.json"),
        symbol_keys: true
      )
      @alexa = AlexaRuby.new(@json)
    end

    it 'should add AudioPlayer.Play directive' do
      @alexa.response.add_audio_player_directive(:start, @audio)
      resp = Oj.load(@alexa.response.json, symbol_keys: true)
      directive = resp[:response][:directives][0]
      directive[:type].must_equal 'AudioPlayer.Play'
      directive[:playBehavior].must_equal 'REPLACE_ALL'
      stream = directive[:audioItem][:stream]
      stream[:url].must_equal @audio[:url]
      stream[:token].must_equal @audio[:token]
      stream[:offsetInMilliseconds].must_equal @audio[:offset]
    end

    it 'should add AudioPlayer.Stop directive' do
      @alexa.response.add_audio_player_directive(:stop)
      resp = Oj.load(@alexa.response.json, symbol_keys: true)
      resp[:response][:directives][0][:type].must_equal 'AudioPlayer.Stop'
    end
  end

  describe 'Speech management' do
    before do
      @json = File.read("#{@req_path}/launch_request.json")
      @alexa = AlexaRuby.new(@json)
    end

    it 'should add plain text output to response' do
      @alexa.response.tell('Test')
      resp = Oj.load(@alexa.response.json, symbol_keys: true)
      resp[:response][:outputSpeech][:type].must_equal 'PlainText'
      resp[:response][:outputSpeech][:text].must_equal 'Test'
      resp[:response][:outputSpeech][:ssml].must_be_nil
    end

    it 'should add SSML output to response' do
      @alexa.response.tell('Test', nil, true)
      resp = Oj.load(@alexa.response.json, symbol_keys: true)
      resp[:response][:outputSpeech][:type].must_equal 'SSML'
      resp[:response][:outputSpeech][:ssml].must_equal '<speak>Test</speak>'
      resp[:response][:outputSpeech][:text].must_be_nil
    end

    it 'should add output with repromt' do
      @alexa.response.tell('Test', 'One more test')
      resp = Oj.load(@alexa.response.json, symbol_keys: true)
      resp[:response][:outputSpeech][:type].must_equal 'PlainText'
      resp[:response][:outputSpeech][:text].must_equal 'Test'
      resp[:response][:outputSpeech][:ssml].must_be_nil
      repromt = resp[:response][:reprompt][:outputSpeech]
      repromt[:type].must_equal 'PlainText'
      repromt[:text].must_equal 'One more test'
      repromt[:ssml].must_be_nil
    end

    it 'should add output speech and return JSON' do
      sample = Oj.to_json(
        Oj.load(File.read("#{@resp_path}/sample_response.json"))
      )
      @alexa.response.tell!('Test').must_equal sample
    end

    it 'should add output speech without closing session' do
      @alexa.response.ask('Test')
      resp = Oj.load(@alexa.response.json, symbol_keys: true)
      resp[:response][:shouldEndSession].must_equal false
    end

    it 'should add output speech without closing session and return JSON' do
      sample = Oj.load(
        File.read("#{@resp_path}/sample_response.json"),
        symbol_keys: true
      )
      sample[:response][:shouldEndSession] = false
      @alexa.response.ask!('Test').must_equal Oj.to_json(sample)
    end
  end
end
