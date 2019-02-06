require_relative '../spec_helper'

describe 'AlexaRuby' do
  before do
    @fpath = 'spec/fixtures/request'
  end

  describe 'BaseRequest' do
    before do
      @json = File.read("#{@fpath}/launch_request.json")
    end

    describe 'Context' do
      it 'should set correct context params' do
        alexa = AlexaRuby.new(@json)
        alexa.request.context.app_id.wont_be_nil
        alexa.request.context.user.wont_be_nil
        alexa.request.context.user.id.wont_be_nil
        alexa.request.context.device.wont_be_nil
        alexa.request.context.device.id.wont_be_nil
        alexa.request.context.audio_state.token.must_be_nil
        alexa.request.context.audio_state.playback_offset.wont_be_nil
        alexa.request.context.audio_state.playback_state.wont_be_nil
      end

      it 'should raise ArgumentError if application ID is missing' do
        req = JSON.parse(@json, symbolize_names: true)
        req[:context][:System][:application][:applicationId] = nil
        err = proc { AlexaRuby.new(req) }.must_raise ArgumentError
        err.message.must_equal 'Missing application ID'
      end

      it 'should raise ArgumentError if user ID is missing' do
        req = JSON.parse(@json, symbolize_names: true)
        req[:context][:System][:user][:userId] = nil
        err = proc { AlexaRuby.new(req) }.must_raise ArgumentError
        err.message.must_equal 'Missing user ID'
      end

      it 'should raise ArgumentError if device ID is missing' do
        req = JSON.parse(@json, symbolize_names: true)
        req[:context][:System][:device][:deviceId] = nil
        err = proc { AlexaRuby.new(req) }.must_raise ArgumentError
        err.message.must_equal 'Missing device ID'
      end

      it 'should remain valid if audio player section is missing' do
        req = JSON.parse(@json, symbolize_names: true)
        req[:context][:AudioPlayer] = nil
        alexa = AlexaRuby.new(req)
        alexa.request.context.audio_state.must_be_nil
      end
    end
  end
end
