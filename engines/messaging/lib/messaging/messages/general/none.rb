module Messaging
  module Messages
    module General

      class None < BaseMessage::Common
        ATTR = []
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
