require_relative '../spec_helper'

describe 'AlexaRuby::Response' do
  before do
    @req_path = 'spec/fixtures/request'
    @resp_path = 'spec/fixtures/response'
  end

  describe 'Session' do
    before do
      @json = File.read("#{@req_path}/launch_request.json")
      @alexa = AlexaRuby.new(@json)
    end

    it 'should add one session attribute correctly' do
      @alexa.response.add_session_attribute(:id, 'djsdhdsjhdsjhdsjh')
      resp = JSON.parse(@alexa.response.json, symbolize_names: true)
      resp[:sessionAttributes][:id].must_equal 'djsdhdsjhdsjhdsjh'
    end

    it 'should add pack of session attributes correctly' do
      @alexa.response.add_session_attributes(
        id: 'djsdhdsjhdsjhdsjh',
        test: 'test'
      )
      resp = JSON.parse(@alexa.response.json, symbolize_names: true)
      resp[:sessionAttributes][:id].must_equal 'djsdhdsjhdsjhdsjh'
      resp[:sessionAttributes][:test].must_equal 'test'
    end

    it 'should merge pack of session attributes correctly' do
      @alexa.response.add_session_attributes(
        id: 'djsdhdsjhdsjhdsjh',
        test: 'test'
      )
      @alexa.response.merge_session_attributes(token: '7783y3h43hg4ghh')
      resp = JSON.parse(@alexa.response.json, symbolize_names: true)
      resp[:sessionAttributes][:id].must_equal 'djsdhdsjhdsjhdsjh'
      resp[:sessionAttributes][:test].must_equal 'test'
      resp[:sessionAttributes][:token].must_equal '7783y3h43hg4ghh'
    end

    it 'should raise ArgumentError if duplicate attribute found' do
      @alexa.response.add_session_attribute(:id, 'djsdhdsjhdsjhdsjh')
      err = proc {
        @alexa.response.add_session_attribute(:id, '833hj33jh3hj')
      }.must_raise ArgumentError
      err.message.must_equal 'Duplicate session attributes not allowed'
    end

    it 'should raise ArgumentError if attributes pack isn\'t a Hash' do
      err = proc {
        @alexa.response.add_session_attributes('Test')
      }.must_raise ArgumentError
      err.message.must_equal 'Attributes must be a Hash'

      err = proc {
        @alexa.response.merge_session_attributes('Test')
      }.must_raise ArgumentError
      err.message.must_equal 'Attributes must be a Hash'
    end
  end
end
