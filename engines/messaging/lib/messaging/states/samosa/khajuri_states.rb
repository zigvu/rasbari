# Note: This relies in monkeypatching of module in
# config/initializers/monkeypatch.rb (for Rails)
# messaging/monkeypatch.rb (for non-Rails)

module Messaging
  module States
    module Samosa

      class KhajuriStates
        def self.states
          ["unknown", "ready", "evaluating", "evaluated", "stopped"]
        end
        zextend BaseNonPersisted, Messaging::States::Samosa::KhajuriStates.states, { prefix: 'state' }

        attr_reader :state

        def initialize(s)
          @state = s
        end
      end

    end
  end
end
