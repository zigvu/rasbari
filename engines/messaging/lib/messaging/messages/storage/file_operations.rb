module Messaging
  module Messages
    module Storage

      class FileOperations < BaseMessage::Common
        CATEGORY = "storage"
        NAME = "file_operations"

        def self.attributes
          [
            "category", "name", "traceback", "hostname", "type",
            "clientFilePath", "serverFilePath"
          ]
        end
        zextend BaseMessage, FileOperations.attributes

        def initialize(message = nil)
          cat = Object.const_get("#{self.class}")::CATEGORY
          nam = Object.const_get("#{self.class}")::NAME
          super(cat, nam, message)
        end

        def getFileOperationType
          Messaging::States::Storage::FileOperationTypes.new(@type)
        end
      end

    end
  end
end
