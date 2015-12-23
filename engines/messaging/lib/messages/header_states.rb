# Note: This relies in monkeypatching of module in
# config/initializers/monkeypatch.rb (for Rails)
# messaging/monkeypatch.rb (for non-Rails)

module Messages
  class HeaderStates
    def self.states
      ["unknown", "success", "failure"]
    end
    zextend BaseNonPersisted, Messages::HeaderStates.states, { prefix: 'state' }

    attr_reader :state

    def initialize(s)
      @state = s
    end
  end
end
