require_relative '../spec_helper'

describe 'AlexaRuby' do
  before do
    @fpath = 'spec/fixtures/request'
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
