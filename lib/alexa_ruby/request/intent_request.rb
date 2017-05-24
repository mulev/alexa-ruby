require 'alexa_ruby/request/intent_request/slot'

module AlexaRuby
  # IntentRequest class implements Alexa "IntentRequest" request type
  class IntentRequest < Request
    attr_accessor :intent, :name, :slots

    # Initialize new Intent request
    #
    # @param json [JSON] valid JSON request from Amazon
    def initialize(json)
      @intent = json[:request][:intent]
      if @intent.nil?
        raise ArgumentError, 'Intent should exist on an IntentRequest'
      end

      @type = :intent
      @name = @intent[:name]
      @slots = @intent[:slots]

      super
    end

    # Takes a Hash object with slots and add it to slots node
    #
    # @param slots [Hash] hash with slots data
    def add_hash_slots(slots)
      raise ArgumentError, 'Slots can\'t be empty' if slots.nil?
      slots.each do |slot|
        @slots[:slot[:name]] = Slot.new(slot[:name], slot[:value])
      end
      @slots
    end

    # Takes a JSON with slots and add it to slots node
    #
    # @param slots [JSON] json object with slots data
    def add_slots(slots)
      slot_hash = Oj.load(slots, symbol_keys: true)
      add_hash_slots(slot_hash)
    end

    # Adds a slot from a name and a value
    #
    # @param name [String] slot name
    # @param value [String] slot value
    # @return [Object] new slot object
    def add_slot(name, value)
      slot = Slot.new(name, value)
      @slots[:name] = slot
      slot
    end

    # Outputs the Intent Name, request Id and slot information
    #
    # @return [String] Intent Name, request Id and slot information
    def to_s
      "IntentRequest: #{name} requestID: #{request_id}  Slots: #{slots}"
    end
  end
end
