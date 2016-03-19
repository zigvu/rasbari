# Note: This relies in monkeypatching of module in
# config/initializers/monkeypatch.rb (for Rails)
# messaging/monkeypatch.rb (for non-Rails)

module Messaging
  module States
    module Samosa

      class OperationTypes
        def self.types
          ["khajuri", "chia"]
        end
        zextend BaseNonPersisted, Messaging::States::Samosa::OperationTypes.types, { prefix: 'type' }

        attr_reader :type

        def initialize(t)
          @type = t
        end
      end

    end
  end
end
