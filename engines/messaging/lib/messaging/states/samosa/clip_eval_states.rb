# Note: This relies in monkeypatching of module in
# config/initializers/monkeypatch.rb (for Rails)
# messaging/monkeypatch.rb (for non-Rails)

module Messaging
  module States
    module Samosa

      class ClipEvalStates
        def self.states
          ["configuring", "downloaded", "evaluated", "ingested", "failed"]
        end
        zextend BaseNonPersisted, Messaging::States::Samosa::ClipEvalStates.states, { prefix: 'state' }

        attr_reader :state

        def initialize(s)
          @state = s
        end
      end

    end
  end
end
