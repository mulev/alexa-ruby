module AlexaRuby
  # Class that encapsulates each slot
  class Slot
    attr_accessor :name, :value, :confirmation_status

    # Initialize slot and define its name and value
    #
    # @param slot [Hash] slot parameters
    def initialize(slot)
      @slot = slot
      raise ArgumentError, 'Missing slot parameters' if invalid_slot?
      @name = @slot[:name]
      @value = @slot[:value]
      @confirmation_status = define_confirmation_status
    end

    private

    # Check if it is a valid slot or not
    #
    # @return [Boolean]
    def invalid_slot?
      @slot[:name].nil? || @slot[:value].nil?
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
  end
end
