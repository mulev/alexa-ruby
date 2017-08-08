# AlexaRuby

[![Gem Version](https://badge.fury.io/rb/alexa_ruby.svg)](https://badge.fury.io/rb/alexa_ruby)
[![Build Status](https://travis-ci.org/mulev/alexa-ruby.svg?branch=master)](https://travis-ci.org/mulev/alexa-ruby)
[![CircleCI](https://circleci.com/bb/mmulev/alexa-ruby/tree/master.svg?style=svg&circle-token=6a8088af16c301880712400c2db43ed32e1291f3)](https://circleci.com/bb/mmulev/alexa-ruby/tree/master)
[![Code Climate](https://codeclimate.com/github/mulev/alexa-ruby/badges/gpa.svg)](https://codeclimate.com/github/mulev/alexa-ruby)
[![Coverage Status](https://coveralls.io/repos/github/mulev/alexa-ruby/badge.svg?branch=develop)](https://coveralls.io/github/mulev/alexa-ruby?branch=develop)

Originally forked from [damianFC's AlexaRubykit](https://github.com/damianFC/alexa-rubykit), this gem implements a convenient back-end service for interaction with Amazon Alexa API.

## Installation

To install and use gem in your project just add this to your Gemfile:

```ruby
gem 'alexa_ruby'
```

And bundle it with:

```bash
$ bundle install
```

Or install it as a separate gem:

```bash
$ gem install alexa_ruby
```

## Docs

|Resource|URL|
|---|---|
|Amazon Alexa Skill Kit docs|[https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/alexa-skills-kit-interface-reference](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/alexa-skills-kit-interface-reference)|
|Rubydoc|[http://www.rubydoc.info/gems/alexa_ruby](http://www.rubydoc.info/gems/alexa_ruby)|
|Source|[https://github.com/mulev/alexa-ruby](https://github.com/mulev/alexa-ruby)|
|Bugs|[https://github.com/mulev/alexa-ruby/issues](https://github.com/mulev/alexa-ruby/issues)|

## Usage

Gem provides a possibility to easily handle requests from Amazon Alexa service and build responses to given requests.

### Getting started

AlexaRuby usage is quite simple, to start you need to require gem in your ruby
file and pass it JSON request from Amazon Alexa service.  
Here and below all examples will be based on Roda routing tree framework, but
you can use any other -- AlexaRuby is a framework independent gem.

```ruby
require 'roda'
require 'alexa_ruby'

class App < Roda
  route do |r|
    r.post do
      r.on 'alexa' do
        alexa = AlexaRuby.new(r.body.read)
      end
    end
  end
end
```

Request structure validations can be disabled:

```ruby
AlexaRuby.new(request, disable_validations: true)
```

If needed, you can validate request signature and Amazon SSL certificates chain. To do so specify several parameters:

```ruby
AlexaRuby.new(
  request,
  certificates_chain_url: url,
  request_signature: signature
)
```

After initializing new AlexaRuby instance you will have a possibility to access
all parameters of the received request.

#### General request parameters

|Access path|Description|
|---|---|
|alexa.request.json|given JSON request|
|alexa.request.version|request version, typically "1.0"|
|alexa.request.type|request type, can be :launch, :intent, :session_ended or :audio_player|
|alexa.request.id|request ID|
|alexa.request.timestamp|request timestamp|
|alexa.request.locale|request locale|

#### Session parameters

Notice that user data exists in two scopes -- session and context.

|Access path|Description|
|---|---|
|alexa.request.session.id|session ID|
|alexa.request.session.attributes|array with all session attributes|
|alexa.request.session.end_reason|session end reason, can be :user_quit, :processing_error or :user_idle|
|alexa.request.session.error|hash with session error info|
|alexa.request.session.state|current session state, can be :new, :old or :ended|
|alexa.request.session.user.id|skill user ID|
|alexa.request.session.user.access_token|user access token if account linking is enabled and user is authenticated|
|alexa.request.session.user.permissions_token|user permissions token|

#### Context parameters

Notice that user data exists in two scopes -- session and context.

|Access path|Description|
|---|---|
|alexa.request.context.app_id|Alexa application ID|
|alexa.request.context.api_endpoint|Alexa API endpoint|
|alexa.request.context.user.id|skill user ID|
|alexa.request.context.user.access_token|user access token if account linking is enabled and user is authenticated|
|alexa.request.context.user.permissions_token|user permissions token|
|alexa.request.context.device.id|user device ID|
|alexa.request.context.device.interfaces|interfaces, supported by user device|

#### Intent request parameters

|Access path|Description|
|---|---|
|alexa.request.intent_name|given intent name|
|alexa.request.dialog_state|state of dialog with user, can be :started, :in_progress or :completed|
|alexa.request.confirmation_status|user confirmation status, can be :unknown, :confirmed or :denied|
|alexa.request.slots|array with all slots from intent|

#### Audio player request parameters

|Access path|Description|
|---|---|
|alexa.request.playback_state|current playback state|
|alexa.request.playback_offset|current playback offset in milliseconds|
|alexa.request.error_type|playback error type|
|alexa.request.error_message|playback error message explaining error|
|alexa.request.error_playback_token|audio player token of failed playback|
|alexa.request.error_player_activity|audio player activity in moment of failure|

### Building response

To build a response take your freshly initialized `alexa` and start using `alexa.response` methods.

#### Add session attributes

It is possible to add one attribute to session scope:

```ruby
alexa.response.add_session_attribute('key', 'value')
```

Exception will be raised if attribute already exists in the session scope.  
If you want to overwrite it, call:

```ruby
alexa.response.add_session_attribute('key', 'value_2', true)
```

You can also add a pack of attributes. To overwrite all existing ones call:

```ruby
alexa.response.add_session_attributes(key: 'value', key_2: 'value_2')
```

To add new attributes and save existing ones call:

```ruby
alexa.response.merge_session_attributes(key: 'value', key_2: 'value_2')
```

#### Add card

Supported card types are: Simple, Standard and LinkAccount.

```ruby
card = {
  type: 'Standard', title: 'Test', content: 'test',
  small_image_url: 'https://test.ru/example_small.jpg',
  large_image_url: 'https://test.ru/example_large.jpg'
}
alexa.response.add_card(card)
```

#### Add audio player directive

Supported directives:

 - AudioPlayer.Play
 - AudioPlayer.ClearQueue
 - AudioPlayer.Stop

To start the whole new playback call:

```ruby
params = { url: 'https://my-site.com/my-stream', token: 'test', offset: 0 }
alexa.response.add_audio_player_directive(:start, params)
```

To enqueue new audio file call:

```ruby
params = { url: 'https://my-site.com/my-stream', token: 'test', offset: 0, play_behavior: :enqueue }
alexa.response.add_audio_player_directive(:start, params)
```

To replace all previously enqueued audio files call:

```ruby
params = { url: 'https://my-site.com/my-stream', token: 'test', offset: 0, play_behavior: :replace_enqueued }
alexa.response.add_audio_player_directive(:start, params)
```

To clear all:

```ruby
alexa.response.add_audio_player_directive(:clear)
```

To clear only enqueued tracks and keep the playing one:

```ruby
alexa.response.add_audio_player_directive(
  :clear,
  clear_behavior: :clear_queue
)
```

To stop playback call:

```ruby
alexa.response.add_audio_player_directive(:stop)
```

#### Get current state of response encoded in JSON

```ruby
alexa.response.json
```

#### Add output speech to response

Ask user a question and wait for response (session will remain open):

```ruby
question = 'What can I do for you?'

alexa.response.ask(question)                  # will add outputSpeech node
alexa.response.ask(question, question)        # outputSpeech node and reprompt node
alexa.response.ask(question, question, true)  # outputSpeech node, reprompt node and both will be converted into SSML

alexa.response.ask!(question)                 # will add outputSpeech node and return JSON encoded response object
```

Tell something to user and end conversation (session will be closed):

```ruby
speech = 'You are awesome!'

alexa.response.tell(speech)               # will add outputSpeech node
alexa.response.tell(speech, speech)       # outputSpeech node and reprompt node
alexa.response.tell(speech, speech, true) # outputSpeech node, reprompt node and both will be converted into SSML

alexa.response.tell!(speech)              # will add outputSpeech node and return JSON encoded response object
```

## Testing

Run all tests with:

```bash
$ rake test
```

Please, feel free to [open an issue](https://github.com/mulev/alexa-ruby/issues/new) in case of any bugs.

## Contributing

You are always welcome to open an issue with some feature request or bug report. Also you can add new features by yourself. To do so, please, follow that steps:

1. Fork master branch of this repo
2. Add a new feature branch in your forked repo and write code
3. Write tests
4. Add pull request from your branch to [alexa_ruby develop branch](https://github.com/mulev/alexa-ruby/tree/develop)

All development is made only in develop branch before being merged to master.

## License

AlexaRuby is released under the [MIT license](https://github.com/mulev/alexa-ruby/blob/master/LICENSE).
