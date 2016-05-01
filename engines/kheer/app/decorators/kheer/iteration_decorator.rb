module Kheer
  class IterationDecorator < Draper::Decorator
    delegate_all

    def toMessage
      needsTempParent = object.detectable_ids.sort != object.builtParentIteration.detectable_ids.sort
      ar = {
        iterationId: object.id,
        chiaModelId: object.chia_model_id,
        parentChiaModelId: object.chia_model.decorate.parent.id,
        needsTempParent: needsTempParent,
        storageHostname: object.storageMachine.hostname,
        storageBuildInputPath: object.buildInputPath,
        storageParentModelPath: object.parentModelPath
      }
      Messaging::Messages::Samosa::ChiaDetails.new(ar)
    end

    def chiaToDetMapNonAvoid
      chiaToDet = {}
      ChiaModel.find(object.chia_model_id).iteration.detectable_ids.each_with_index do |d, idx|
        det = Detectable.find(d)
        chiaToDet[idx.to_s] = d if !det.type.isAvoid?
      end
      chiaToDet
    end

    def chiaToDetMapAvoid
      chiaToDet = {}
      ChiaModel.find(object.chia_model_id).iteration.detectable_ids.each_with_index do |d, idx|
        det = Detectable.find(d)
        chiaToDet[idx.to_s] = d if det.type.isAvoid?
      end
      chiaToDet
    end

  end
end
