require_relative '../spec_helper'

describe 'AlexaRuby' do
  before do
    @fpath = 'spec/fixtures/request'
  end

  describe 'IntentRequestWithResolutions' do
    before do
      @json = File.read("#{@fpath}/resolution_success_request.json")
    end

    it 'should parse valid IntentRequest correctly' do
      alexa = AlexaRuby.new(@json)
      alexa.request.type.must_equal :intent
      alexa.request.intent_name.must_equal 'RebuildLatest'
      alexa.request.confirmation_status.must_equal :confirmed
      alexa.request.dialog_state.must_equal :completed
      alexa.request.slots[1].name.must_equal 'statusFilter'
    end

    it 'resolved_values should return expected values' do
      alexa = AlexaRuby.new(@json)
      alexa.request.slots[1].name.must_equal 'statusFilter'
      alexa.request.slots[1].resolved_values.each do |resolved_value|
        resolved_value.name.must_equal "both"
        resolved_value.id.must_equal "BOTH"
      end
    end
  end
end
