module Kheer
  class IterationDecorator < Draper::Decorator
    delegate_all

    def toMessage
      ar = {
        iterationId: object.id,
        storageHostname: object.storageMachine.hostname,
        storageBuildInputPath: object.buildInputPath,
        storageParentModelPath: object.parentModelPath
      }
      Messaging::Messages::Samosa::ChiaDetails.new(ar)
    end

  end
end
