module AlexaRuby
  # Class handles the session object in request
  class Session
    attr_accessor :new, :session_id, :attributes, :user

    # Initialize new user session
    #
    # @param session [JSON] part of json request from Amazon with user session
    def initialize(session)
      if session.nil? || session[:new].nil? || session[:sessionId].nil?
        raise ArgumentError, 'Invalid Session'
      end

      @new = session[:new]
      @session_id = session[:sessionId]
      @attributes = session[:attributes].nil? ? {} : session[:attributes]
      @user = session[:user]
    end

    # Is it a new user session?
    #
    # @return [Boolean]
    def new?
      @new
    end

    # Is user defined?
    #
    # @return [Boolean]
    def user_defined?
      !@user.nil? || !@user[:userId].nil?
    end

    # Get user ID
    #
    # @return [String] Amazon user ID
    def user_id
      @user[:userId] if @user
    end

    # Get user access token
    #
    # @return [String] Amazon user access token
    def access_token
      @user[:accessToken] if @user
    end

    # Session attributes present?
    #
    # @return [Boolean]
    def attributes?
      !@attributes.empty?
    end
  end
end
