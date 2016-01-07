module Messaging
  module Messages
    module Storage

      class ClientDetails < BaseMessage::Common
        CATEGORY = "storage"
        NAME = "client_details"

        def self.attributes
          ["category", "name", "hostname", "type"]
        end
        zextend BaseMessage, ClientDetails.attributes

        def initialize(message = nil)
          cat = Object.const_get("#{self.class}")::CATEGORY
          nam = Object.const_get("#{self.class}")::NAME
          super(cat, nam, message)
        end

        def getStorageClientType
          Messaging::States::Storage::ClientTypes.new(@type)
        end
      end

    end
  end
end
