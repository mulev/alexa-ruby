module AlexaRuby
  # Amazon Alexa request context - application, user and device info
  class Context
    attr_reader :app_id, :user, :device, :api_endpoint, :audio_state

    # Initialize new Context object
    #
    # @param context [Hash] request context parameters
    # @raise [ArgumentError] if application ID, or user ID, or device ID are nil
    def initialize(context)
      @app_id = get_app_id(context[:System][:application])
      raise ArgumentError, 'Missing application ID' unless @app_id

      @user = load_user(context[:System][:user])
      @device = load_device(context[:System][:device])
      @api_endpoint = context[:System][:apiEndpoint]
      @audio_state = load_audio_state(context[:AudioPlayer])
    end

    private

    # Get application ID
    #
    # @param app [Hash] application parameters
    # @return [String] application ID
    def get_app_id(app)
      app[:applicationId] unless app[:applicationId].nil?
    end

    # Initialize user parameters
    #
    # @param params [Hash] user parameters
    # @return [Object] new User object instance
    def load_user(params)
      User.new(params)
    end

    # Initialize user device parameters
    #
    # @param params [Hash] user device parameters
    # @return [Object] new Device object instance
    def load_device(params)
      Device.new(params)
    end

    # Initialize audio player state
    #
    # @param params [Hash] audio player parameters
    # @return [Object] new AudioState object instance
    def load_audio_state(params)
      AudioState.new(params) unless params.nil?
    end
  end
end
