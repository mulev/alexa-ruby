module AlexaRuby
  # User device parameters
  class Device
    attr_reader :id, :interfaces

    # Initialize new device
    #
    # @param device [Hash] user device parameters
    # @raise [ArgumentError] if device ID is nil
    def initialize(device)
      raise ArgumentError, 'Missing device ID' if device[:deviceId].nil?
      @id = device[:deviceId]
      load_interfaces(device[:supportedInterfaces])
    end

    private

    # Load supported interfaces
    #
    # @param device [Hash] supported interfaces list
    def load_interfaces(device)
      @interfaces = []
      device.each do |k, _|
        @interfaces << k
      end
    end
  end
end
