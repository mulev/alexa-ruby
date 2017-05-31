module AlexaRuby
  # Amazon Alexa user
  class User
    attr_reader :id, :access_token, :permissions_token

    # Initialize new user
    #
    # @param user [Hash] user parameters
    # @raise [ArgumentError] if user ID is nil
    def initialize(user)
      raise ArgumentError, 'Missing user ID' if user[:userId].nil?
      @id = user[:userId]
      @access_token = user[:accessToken] unless user[:accessToken].nil?
      return if user[:permissions].nil?
      @permissions_token = permissions(user[:permissions])
    end

    private

    # Get user permissions token
    #
    # @param permissions [Hash] user permissions object
    # @return [String] user permissions consent token
    def permissions(permissions)
      permissions[:consentToken] unless permissions[:consentToken].nil?
    end
  end
end
