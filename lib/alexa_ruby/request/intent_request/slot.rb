module AlexaRuby
  # Class that encapsulates each slot
  class Slot
    attr_accessor :name, :value, :confirmation_status, :resolution_authorities, :resolved_values

    # Initialize slot and define its name and value
    #
    # @param slot [Hash] slot parameters
    def initialize(slot)
      @slot = slot
      raise ArgumentError, 'Missing slot parameters' if invalid_slot?
      @name = @slot[:name]
      @value = @slot[:value]
      @confirmation_status = define_confirmation_status
      @resolution_authorities = define_resolution_authorities
      @resolved_values = define_resolved_values
    end

    private

    # Check if it is a valid slot or not
    #
    # @return [Boolean]
    def invalid_slot?
      @slot[:name].nil?
    end

    # Define user confirmation status
    #
    # @return [Symbol] current confirmation status
    def define_confirmation_status
      case @slot[:confirmationStatus]
      when 'NONE'
        :unknown
      when 'CONFIRMED'
        :confirmed
      when 'DENIED'
        :denied
      end
    end

    # Define entity resolution authorities
    #
    # @return [Array] resolution authorities
    def define_resolution_authorities
      authorities = @slot.dig(:resolutions, :resolutionsPerAuthority)
        &.map { |resolution_authority| ResolutionAuthority.new(resolution_authority) }
      authorities || []
    end

    # Define entity resolution values
    #
    # @return [Array] resolved values
    def define_resolved_values
        @resolution_authorities.map(&:values)&.flatten
    end
  end
end
