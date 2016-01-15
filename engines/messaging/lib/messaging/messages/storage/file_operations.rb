module Messaging
  module Messages
    module Storage

      class FileOperations < BaseMessage::Common
        ATTR = ["hostname", "type", "clientFilePath", "serverFilePath"]
        zextend BaseMessage, ATTR

        def initialize(message = nil)
          super(_category, _name, message)
        end

        def getFileOperationType
          Messaging::States::Storage::FileOperationTypes.new(@type)
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
