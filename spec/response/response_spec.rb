require_relative '../spec_helper'

describe 'AlexaRuby' do
  before do
    @req_path = 'spec/fixtures/request'
    @resp_path = 'spec/fixtures/response'
  end

  describe 'Response' do
    before do
      @json = File.read("#{@req_path}/launch_request.json")
      @alexa = AlexaRuby.new(@json)
    end

    it 'should build a Response object for valid JSON' do
      @alexa.response.wont_be_nil
      resp = JSON.parse(@alexa.response.json, symbolize_names: true)
      resp[:version].wont_be_nil
      resp[:response][:shouldEndSession].must_equal true
    end
  end
end
