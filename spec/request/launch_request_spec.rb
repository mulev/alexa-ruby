require_relative '../spec_helper'

describe 'AlexaRuby' do
  before do
    @fpath = 'spec/fixtures/request'
  end

  describe 'LaunchRequest' do
    before do
      @json = File.read("#{@fpath}/launch_request.json")
    end

    it 'should parse valid LaunchRequest correctly' do
      alexa = AlexaRuby.new(@json)
      alexa.request.type.must_equal :launch
    end
  end
end
