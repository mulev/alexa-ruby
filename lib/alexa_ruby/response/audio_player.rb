require 'securerandom'
require 'uri'

module AlexaRuby
  # AudioPlayer class encapsulates all Alexa audio player directives
  class AudioPlayer
    attr_accessor :directive
    
    # Initialize new directive object
    def initialize
      @directive = {}
    end

    # Build an AudioPlayer.Play directive
    #
    # @param opts [Hash] optional request parameters:
    #                     - streaming URL
    #                     - radio station token
    #                     - expected previous station token
    #                     - playback offset
    # @return [Hash] AudioPlayer.Play directive
    def build_play_directive(opts)
      raise ArgumentError, 'Invalid streaming URL' unless valid_url?(opts[:url])
      token = opts[:token] || SecureRandom.uuid
      offset = opts[:offset] || 0
      @directive[:type] = 'AudioPlayer.Play'
      @directive[:playBehavior] = 'REPLACE_ALL'
      @directive[:audioItem] = { stream: {} }
      @directive[:audioItem][:stream][:url] = opts[:url]
      @directive[:audioItem][:stream][:token] = token
      @directive[:audioItem][:stream][:offsetInMilliseconds] = offset
    end

    # Build AudioPlayer.Stop directive
    #
    # @return [Hash] AudioPlayer.Stop directive
    def build_stop_directive
      @directive[:type] = 'AudioPlayer.Stop'
    end

    private

    # Is it a valid URL?
    #
    # @param url [String] streaming URL
    # @return [Boolean]
    def valid_url?(url)
      url =~ /\A#{URI.regexp(['https'])}\z/
    end
  end
end
