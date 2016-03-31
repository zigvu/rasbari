# Note: This relies in monkeypatching of module in
# config/initializers/monkeypatch.rb (for Rails)
# messaging/monkeypatch.rb (for non-Rails)

module Messaging
  module States
    module Samosa

      class ChiaStates
        def self.states
          ["unknown", "ready", "downloading", "extracting", "building",
            "failed", "built", "uploaded", "stopped"]
        end
        zextend BaseNonPersisted, Messaging::States::Samosa::ChiaStates.states, { prefix: 'state' }

        attr_reader :state

        def initialize(s)
          @state = s
        end
      end

    end
  end
end
