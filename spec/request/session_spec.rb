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
      end

      it 'should raise ArgumentError if session isn\'t valid' do
        req = Oj.load(@json, symbol_keys: true)
        req[:session] = nil
        err = proc { AlexaRuby.new(req) }.must_raise ArgumentError
        err.message.must_equal 'Empty user session'
      end
    end
  end
end
