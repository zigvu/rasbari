module Messaging
  module Messages
    module Storage

      class ClientDetails < BaseMessage::Common
        ATTR = ["hostname"]
        zextend BaseMessage, ATTR

        def initialize(message = nil)
          super(_category, _name, message)
        end

        private
          def _category
            __FILE__.split("/")[-2]
          end
          def _name
            File.basename(__FILE__, ".*")
          end
        # end private
      end

    end
  end
end
