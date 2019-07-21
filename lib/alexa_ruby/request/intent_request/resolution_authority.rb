module AlexaRuby
  # Class that encapsulates each slot
  class ResolutionAuthority
    attr_accessor :authority, :status_code, :values

    # Initialize slot and define its name and value
    #
    # @param resolution_authority [Hash] resolution_authority parameters
    def initialize(resolution_authority)
      @resolution_authority = resolution_authority
      @authority = @resolution_authority[:authority]
      @status_code = define_status_code
      @values = @resolution_authority[:values]&.map { |value| OpenStruct.new(value[:value]) } || []
    end

    private

    # Define user confirmation status
    #
    # @return [Symbol] current authority status code
    def define_status_code
      case @resolution_authority.dig(:status, :code)
      when 'ER_SUCCESS_MATCH'
        :success_match
      when 'ER_SUCCESS_NO_MATCH'
        :success_no_match
      when 'ER_ERROR_TIMEOUT'
        :error_timeout
      when 'ER_ERROR_EXCEPTION'
        :error_exception
      end
    end
  end
end
