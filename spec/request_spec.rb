require 'rspec'
require 'alexa_ruby'

describe 'Request handling' do

  it 'should accept a proper alexa launch request object' do
    sample_request = File.read('fixtures/LaunchRequest.json')
    request = AlexaRuby.build_request(sample_request)
    expect(request.type).to eq(:launch)
  end

  it 'should correctly identify valid AWS requests' do
    sample_bad_request = { foo: 'bar' }
    expect(AlexaRuby.valid_request?(sample_bad_request)).to be_falsey

    sample_good_request = Oj.load(File.read('fixtures/sample-IntentRequest.json'), symbol_keys: true)
    expect(AlexaRuby.valid_request?(sample_good_request)).to be_truthy
  end

  it 'should raise an exception when an invalid request is sent' do
    sample_request = 'invalid object!'
    expect { AlexaRuby.build_request(sample_request) }.to raise_error(ArgumentError)
    sample_request = nil
    expect { AlexaRuby.build_request(sample_request) }.to raise_error(ArgumentError)
  end

  it 'should create valid intent request type' do
    sample_request = File.read('fixtures/sample-IntentRequest.json')
    intent_request = AlexaRuby.build_request(sample_request)
    expect(intent_request.type).to eq(:intent)
    expect(intent_request.request_id).not_to be_empty
    expect(intent_request.intent).not_to be_empty
    expect(intent_request.name).to eq('GetZodiacHoroscopeIntent')
    expect(intent_request.slots).not_to be_empty
  end

  it 'should create a valid session end request type' do
    sample_request = File.read('fixtures/sample-SessionEndedRequest.json')
    intent_request = AlexaRuby.build_request(sample_request)
    expect(intent_request.type).to eq(:session_ended)
    expect(intent_request.request_id).not_to be_empty
    expect(intent_request.reason).to eq('USER_INITIATED')
  end

  it 'should create valid sessions with attributes' do
    sample_request = File.read('fixtures/sample-IntentRequest.json')
    intent_request = AlexaRuby.build_request(sample_request)
    expect(intent_request.session.new?).to be_falsey
    expect(intent_request.session.attributes?).to be_truthy
    expect(intent_request.session.user_defined?).to be_truthy
    expect(intent_request.session.attributes).not_to be_empty
  end
end
