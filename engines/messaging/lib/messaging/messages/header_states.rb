# Note: This relies in monkeypatching of module in
# config/initializers/monkeypatch.rb (for Rails)
# messaging/monkeypatch.rb (for non-Rails)

module Messaging
  module Messages
    class HeaderStates
      def self.states
        ["request", "unknown", "success", "failure"]
      end
      zextend BaseNonPersisted, Messaging::Messages::HeaderStates.states, { prefix: 'state' }

      attr_reader :state

      def initialize(s)
        @state = s
      end
    end
  end
end
