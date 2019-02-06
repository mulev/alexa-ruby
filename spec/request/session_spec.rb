require_relative '../spec_helper'

describe 'AlexaRuby' do
  before do
    @fpath = 'spec/fixtures/request'
  end

  describe 'BaseRequest' do
    before do
      @json = File.read("#{@fpath}/launch_request.json")
    end

    describe 'Session' do
      it 'should set correct session params' do
        alexa = AlexaRuby.new(@json)
        alexa.request.session.state.wont_be_nil
        alexa.request.session.id.wont_be_nil
        alexa.request.session.user.wont_be_nil
        alexa.request.session.user.id.wont_be_nil
      end

      it 'should set OAuth access token if it is present in request' do
        req = JSON.parse(@json, symbolize_names: true)
        req[:session][:user][:accessToken] = 'test'
        alexa = AlexaRuby.new(req)
        alexa.request.session.user.access_token.must_equal 'test'
      end

      it 'should raise ArgumentError if session isn\'t valid' do
        req = JSON.parse(@json, symbolize_names: true)
        req[:session] = nil
        err = proc { AlexaRuby.new(req) }.must_raise ArgumentError
        err.message.must_equal 'Empty user session'
      end

      it 'should raise ArgumentError if user ID is missing' do
        req = JSON.parse(@json, symbolize_names: true)
        req[:session][:user][:userId] = nil
        err = proc { AlexaRuby.new(req) }.must_raise ArgumentError
        err.message.must_equal 'Missing user ID'
      end
    end
  end
end
