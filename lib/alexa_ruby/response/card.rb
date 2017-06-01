module AlexaRuby
  # Class for Amazon Alexa app cards
  class Card
    attr_reader :obj

    # Initialize new card object
    #
    # @param params [Hash] card parameters:
    #   type [String] card type, can be "Simple", "Standard" or "LinkAccount"
    #   title [String] card title
    #   content [String] card content (line breaks must be already included)
    #   small_image_url [String] an URL for small card image
    #   large_image_url [String] an URL for large card image
    # @return [Hash] ready to use card object
    # @raise [ArgumentError] if card type is unknown
    def initialize(params)
      @obj = {}
      @obj[:type] = params[:type] || 'Simple'
      raise ArgumentError, 'Unknown card type' unless valid_type?
      @params = params
      build
    end

    private

    # Check if card type is valid
    #
    # @return [Boolean]
    def valid_type?
      %w[Simple Standard LinkAccount].include? @obj[:type]
    end

    # Build card object
    #
    # @return [Hash] ready to use card object
    def build
      return if @obj[:type] == 'LinkAccount'
      add_title
      add_content unless @params[:content].nil?
      return unless @obj[:type] == 'Standard'
      return if @params[:small_image_url].nil? &&
                @params[:large_image_url].nil?
      add_images
    end

    # Add card title to object
    #
    # @raise [ArgumentError] if not title found
    def add_title
      raise ArgumentError, 'Card need a title' if @params[:title].nil?
      @obj[:title] = @params[:title]
    end

    # Add content to card body.
    # Content must be already prepared and contain needed line breaks.
    # \r\n or \n can be used for line breaks
    def add_content
      type =
        case @obj[:type]
        when 'Simple'
          :content
        when 'Standard'
          :text
        end
      @obj[type] = @params[:content]
    end

    # Add images to card
    def add_images
      @obj[:image] = {}

      if @params[:small_image_url]
        add_image(:smallImageUrl, @params[:small_image_url])
      end

      return unless @params[:large_image_url]
      add_image(:largeImageUrl, @params[:large_image_url])
    end

    # Add image to object
    #
    # @param type [Symbol] image type
    # @param image_url [String] image URL
    # @raise [ArgumentError] if card URL doesn't starts with HTTPS
    def add_image(type, image_url)
      if invalid_url?(image_url)
        raise ArgumentError, 'Card image URL must be a valid ' \
                              'SSL-enabled (HTTPS) endpoint'
      end
      @obj[:image][type] = image_url
    end

    # Check if given URL isn't an SSL-enabled endpoint
    #
    # @param url [String] some URL
    # @return [Boolean]
    def invalid_url?(url)
      URI.parse(url).scheme != 'https'
    end
  end
end
