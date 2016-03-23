module Messaging
  module Messages
    module Samosa

      class ClipEvalDetails < BaseMessage::Common
        ATTR = ["capEvalId", "clipId", "localClipPath", "storageHostname",
          "localResultPath", "storageResultPath", "state"]
        zextend BaseMessage, ATTR

        def initialize(message = nil)
          super(_category, _name, message)
        end

        def getClipEvalState
          Messaging::States::Samosa::ClipEvalStates.new(@state)
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
