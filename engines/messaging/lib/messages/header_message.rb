module Messages
  class HeaderMessage
    attr_accessor :type, :state

    def initialize(jsonHdr)
      @type = jsonHdr[:type]
      @state = jsonHdr[:state]
    end

    def to_json
      { type: @type, state: @state }
    end

    def self.getSuccess
      return Messaging::HeaderMessage.new({ type: 'status', state: 'success' })
    end
    def isSuccess?
      self == Messaging::HeaderMessage.getSuccess
    end

    def self.getFailure
      return Messaging::HeaderMessage.new({ type: 'status', state: 'failure' })
    end
    def isFailure?
      self == Messaging::HeaderMessage.getFailure
    end

    def self.ping
      return Messaging::HeaderMessage.new({ type: 'ping' })
    end
    def isPing?
    end

    def ==(hdr)
      self.to_json == hdr.to_json
    end
  end
end
