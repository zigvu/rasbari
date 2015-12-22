# Note: This relies in monkeypatching of module in
# config/initializers/monkeypatch.rb (for Rails)
# messaging/monkeypatch.rb (for non-Rails)

module Messages
  class States
    def self.states
      ["unknown", "success", "failure"]
    end
    zextend BaseNonPersisted, Messages::States.states, { prefix: 'state' }

    attr_reader :state

    def initialize(s)
      @state = s
    end
  end
end
