require_relative '../spec_helper'

describe 'AlexaRuby' do
  before do
    @fpath = 'spec/fixtures/request'
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
      req = JSON.parse(@json, symbolize_names: true)
      req[:request][:intent] = nil
      err = proc { AlexaRuby.new(req) }.must_raise ArgumentError
      err.message.must_equal 'Intent must be defined'
    end
  end
end
