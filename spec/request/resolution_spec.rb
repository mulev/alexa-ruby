require_relative '../spec_helper'

describe 'AlexaRuby' do
  before do
    @fpath = 'spec/fixtures/request'
  end

  describe 'IntentRequestWithResolutions' do
    before do
      @json = File.read("#{@fpath}/resolution_request.json")
    end

    it 'should parse valid IntentRequest correctly' do
      alexa = AlexaRuby.new(@json)
      alexa.request.type.must_equal :intent
      alexa.request.intent_name.must_equal 'RebuildLatest'
      alexa.request.confirmation_status.must_equal :confirmed
      alexa.request.dialog_state.must_equal :completed
      alexa.request.slots[0].name.must_equal 'statusFilter'
    end

    it 'no match authority with no resolved_values should return empty array' do
      alexa = AlexaRuby.new(@json)
      alexa.request.slots[0].name.must_equal 'statusFilter'
      alexa.request.slots[0].resolution_authorities.first.status_code.must_equal :success_no_match
      alexa.request.slots[0].resolved_values.must_equal []
    end
  end
end
