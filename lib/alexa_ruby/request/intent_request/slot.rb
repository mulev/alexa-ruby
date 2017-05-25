module AlexaRuby
  # Class that encapsulates each slot
  class Slot
    attr_accessor :name, :value

    # Initialize slot and define its name and value
    #
    # @param name [String] slot name
    # @param value [String] slot value
    def initialize(name, value)
      raise ArgumentError, 'Need a name and a value' if name.nil? || value.nil?
      @name = name
      @value = value
    end

    # Outputs Slot name and value
    #
    # @return [String] Slot name and value
    def to_s
      "Slot Name: #{name}, Value: #{value}"
    end
  end
end
