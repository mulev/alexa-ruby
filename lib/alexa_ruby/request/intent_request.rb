module AlexaRuby
  # IntentRequest class implements Alexa "IntentRequest" request type
  class IntentRequest < BaseRequest
    attr_reader :intent_name, :dialog_state, :confirmation_status, :slots

    # Initialize new Intent request
    #
    # @param request [Hash] valid request from Amazon Alexa service
    def initialize(request)
      @type = :intent
      super
      if @req[:request][:intent].nil?
        raise ArgumentError, 'Intent must be defined'
      end
      @intent = @req[:request][:intent]
      @dialog_state = define_dialog_state
      @intent_name = @intent[:name]
      @confirmation_status = define_confirmation_status
      parse_slots unless @intent[:slots].nil?
    end

    private

    # Define current dialog state
    #
    # @return [Symbol] current dialog state
    def define_dialog_state
      case @req[:request][:dialogState]
      when 'STARTED'
        :started
      when 'IN_PROGRESS'
        :in_progress
      when 'COMPLETED'
        :completed
      end
    end

    # Define user confirmation status
    #
    # @return [Symbol] current confirmation status
    def define_confirmation_status
      case @intent[:confirmationStatus]
      when 'NONE'
        :unknown
      when 'CONFIRMED'
        :confirmed
      when 'DENIED'
        :denied
      end
    end

    # Parse slots and initialize each slot
    def parse_slots
      @slots = []
      @intent[:slots].each do |_, v|
        @slots << Slot.new(v)
      end
    end
  end
end
