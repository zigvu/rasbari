module Messages
  class Header
    attr_accessor :type, :state

    def initialize(jsonHeader)
      @type = Messages::Types.new(jsonHeader['type'])
      @state = Messages::States.new(jsonHeader['state'])
    end
    def to_json
      { type: @type.to_s, state: @state.to_s }
    end
    def to_s
      to_json.to_s
    end

    def self.ping
      jsonHeader = {
        'type' => Messages::Types.new(nil).ping,
        'state' => Messages::States.new(nil).unknown
      }
      return Messages::Header.new(jsonHeader)
    end
    def self.pingSuccess
      jsonHeader = {
        'type' => Messages::Types.new(nil).ping,
        'state' => Messages::States.new(nil).success
      }
      return Messages::Header.new(jsonHeader)
    end
    def self.pingFail
      jsonHeader = {
        'type' => Messages::Types.new(nil).ping,
        'state' => Messages::States.new(nil).failure
      }
      return Messages::Header.new(jsonHeader)
    end
  end
end
