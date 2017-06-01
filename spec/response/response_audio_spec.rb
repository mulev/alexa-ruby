require_relative '../spec_helper'

describe 'AlexaRuby::Response' do
  before do
    @req_path = 'spec/fixtures/request'
    @resp_path = 'spec/fixtures/response'
  end

  describe 'AudioPlayer' do
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

    it 'should raise ArgumentError if audio URL isn\'t SSL-enabled' do
      @audio[:url] = 'http://test.ru/stream'
      err = proc {
        @alexa.response.add_audio_player_directive(:start, @audio)
      }.must_raise ArgumentError
      err.message.must_equal 'Audio URL must be a valid ' \
                              'SSL-enabled (HTTPS) endpoint'
    end

    it 'should raise ArgumentError if audio URL isn\'t a valid URL' do
      @audio[:url] = 'test'
      err = proc {
        @alexa.response.add_audio_player_directive(:start, @audio)
      }.must_raise ArgumentError
      err.message.must_equal 'Audio URL must be a valid ' \
                              'SSL-enabled (HTTPS) endpoint'
    end
  end
end
