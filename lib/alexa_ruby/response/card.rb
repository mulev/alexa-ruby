module AlexaRuby
  # Class for Amazon Alexa app cards
  class Card
    attr_accessor :obj

    # Initialize new card object
    def initialize
      @obj = {}
    end

    # Build card object
    #
    # @param opts [Hash] card parameters:
    #                     - type - card type
    #                     - title - card title
    #                     - subtitle - card subtitle
    #                     - content - card body content
    def build(opts)
      @obj[:type] = opts[:type]
      @obj[:title] = opts[:title] unless opts[:title].nil?
      @obj[:subtitle] = opts[:subtitle] unless opts[:subtitle].nil?
      @obj[:content] = opts[:content] unless opts[:content].nil?
    end
  end
end
