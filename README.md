# AlexaRuby

[![Gem Version](https://badge.fury.io/rb/alexa_ruby.svg)](https://badge.fury.io/rb/alexa_ruby)
[![Build Status](https://travis-ci.org/mulev/alexa-ruby.svg?branch=master)](https://travis-ci.org/mulev/alexa-ruby)

Originally forked from [damianFC's AlexaRubykit](https://github.com/damianFC/alexa-rubykit), this gem implements a back-end service for interaction with Amazon Alexa API.

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

## Usage

Gem provides methods to handle requests from Amazon Alexa skill and to sent it a proper response.

You can quickly try it with that sample code:

```ruby
require 'alexa_ruby'

response = AlexaRuby::Response.new
response.add_speech('Yay, ruby is running!')
response.build_response
```

It will generate valid outspeech JSON:

```JSON
{
  "version": "1.0",
  "response": {
    "outputSpeech": {
      "type": "PlainText",
      "text": "Yay, ruby is running!"
    },
    "shouldEndSession": true
  }
}
```

## Testing

Run the tests using

```bash
bundle exec rspec --color --format=documentation
```
