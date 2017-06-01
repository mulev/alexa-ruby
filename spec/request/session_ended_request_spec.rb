require_relative '../spec_helper'

describe 'AlexaRuby' do
  before do
    @fpath = 'spec/fixtures/request'
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
end
