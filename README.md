# AlexaRuby

[![Gem Version](https://badge.fury.io/rb/alexa_ruby.svg)](https://badge.fury.io/rb/alexa_ruby)
[![Build Status](https://travis-ci.org/mulev/alexa-ruby.svg?branch=master)](https://travis-ci.org/mulev/alexa-ruby)
[![Code Climate](https://codeclimate.com/github/mulev/alexa-ruby/badges/gpa.svg)](https://codeclimate.com/github/mulev/alexa-ruby)

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
|Rubydoc|[http://www.rubydoc.info/gems/alexa_ruby](http://www.rubydoc.info/gems/alexa_ruby)|
|Source|[https://github.com/mulev/alexa-ruby](https://github.com/mulev/alexa-ruby)|
|Bugs|[https://github.com/mulev/alexa-ruby/issues](https://github.com/mulev/alexa-ruby/issues)|

## Usage

Gem provides a possibility to easily handle requests from Amazon Alexa service and build responses to given requests.
Usage is as easy as:

```ruby
require 'alexa_ruby'

alexa = AlexaRuby.new(request) # request is a HTTP request body
alexa.response.tell!('Ruby is awesome!')
```

This simple example will return a valid JSON with response to Amazon Alexa service request:

```json
{
  "version": "1.0",
  "sessionAttributes": {},
  "response": {
    "shouldEndSession": true,
    "outputSpeech": {
      "type": "PlainText",
      "text": "Ruby is awesome!"
    }
  }
}

```

Gem can be used with any framework - Rails, Sinatra, Cuba, Roda, or any other that can handle HTTP requests and responses.

## Testing

Run all tests with

```bash
$ rake test
```
