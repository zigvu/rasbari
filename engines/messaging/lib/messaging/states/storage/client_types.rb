# Note: This relies in monkeypatching of module in
# config/initializers/monkeypatch.rb (for Rails)
# messaging/monkeypatch.rb (for non-Rails)

module Messaging
  module States
    module Storage

      class ClientTypes
        def self.types
          ["rasbari", "capture", "storage"]
        end
        zextend BaseNonPersisted, Messaging::States::Storage::ClientTypes.types, { prefix: 'type' }

        attr_reader :type

        def initialize(t)
          @type = t
        end
      end

    end
  end
end