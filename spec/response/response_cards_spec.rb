require_relative '../spec_helper'

describe 'AlexaRuby::Response' do
  before do
    @req_path = 'spec/fixtures/request'
    @resp_path = 'spec/fixtures/response'
  end

  describe 'Card' do
    before do
      @json = File.read("#{@req_path}/launch_request.json")
      @card = JSON.parse(
        File.read("#{@resp_path}/sample_card.json"),
        symbolize_names: true
      )
      @alexa = AlexaRuby.new(@json)
    end

    it 'should add card to response' do
      @alexa.response.add_card(@card)
      resp = JSON.parse(@alexa.response.json, symbolize_names: true)
      resp[:response][:card][:type].must_equal 'Simple'
      resp[:response][:card][:title].must_equal 'title'
      resp[:response][:card][:content].must_equal 'text'
    end

    it 'should raise ArgumentError if card not allowed in response' do
      alexa = AlexaRuby.new(File.read("#{@req_path}/audio_player_request.json"))
      err = proc { alexa.response.add_card(@card) }.must_raise ArgumentError
      err.message.must_equal 'Card can only be included in response ' \
                              'to a "LaunchRequest" or "IntentRequest"'
    end

    it 'should add "text" and "image" nodes if card type is Standard' do
      @card[:type] = 'Standard'
      @alexa.response.add_card(@card)
      resp = JSON.parse(@alexa.response.json, symbolize_names: true)
      small_url = 'https://test.ru/example_small.jpg'
      large_url = 'https://test.ru/example_large.jpg'
      resp[:response][:card][:type].must_equal 'Standard'
      resp[:response][:card][:text].must_equal 'text'
      resp[:response][:card][:image][:smallImageUrl].must_equal small_url
      resp[:response][:card][:image][:largeImageUrl].must_equal large_url
    end

    it 'should raise ArgumentError if no title given' do
      @card[:title] = nil
      err = proc { @alexa.response.add_card(@card) }.must_raise ArgumentError
      err.message.must_equal 'Card need a title'
    end

    it 'should raise ArgumentError if card type unknown' do
      @card[:type] = 'Test'
      err = proc { @alexa.response.add_card(@card) }.must_raise ArgumentError
      err.message.must_equal 'Unknown card type'
    end

    it 'should raise ArgumentError if image URL isn\'t SSL-enabled' do
      @card[:type] = 'Standard'
      @card[:small_image_url] = 'http://test.ru/image.jpeg'
      err = proc { @alexa.response.add_card(@card) }.must_raise ArgumentError
      err.message.must_equal 'Card image URL must be a valid ' \
                              'SSL-enabled (HTTPS) endpoint'
    end

    it 'should raise ArgumentError if image URL isn\'t a valid URL' do
      @card[:type] = 'Standard'
      @card[:small_image_url] = 'test'
      err = proc { @alexa.response.add_card(@card) }.must_raise ArgumentError
      err.message.must_equal 'Card image URL must be a valid ' \
                              'SSL-enabled (HTTPS) endpoint'
    end
  end
end
