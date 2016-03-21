module Kheer
  class CaptureEvaluation
    include Mongoid::Document
    include Mongoid::Timestamps::Created

    # meta data for indexing
    # -------------------------------------------
    field :cpi, as: :capture_id, type: Integer
    field :ci, as: :chia_model_id, type: Integer
    field :ui, as: :user_id, type: Integer

    field :gid, as: :gpu_machine_id, type: Integer
    field :st, as: :zstate, type: String

    # index for faster traversal during ordering
    # -------------------------------------------
    index({ capture_id: 1 }, { background: true })
    index({ chia_model_id: 1 }, { background: true })

    # convenience methods
    # -------------------------------------------
    def state
      Kheer::CaptureEvaluationStates.new(self)
    end

    def capture
      return Video::Capture.find(self.capture_id)
    end

    def chia_model
      return ChiaModel.find(self.chia_model_id)
    end

    def storageMachine
      capture.storageMachine
    end
    def gpuMachine
      self.gpu_machine_id ? Setting::Machine.find(self.gpu_machine_id) : nil
    end

    def storageClient
      Messaging.rasbari_cache.storage.client(storageMachine.hostname)
    end
    def samosaClient
      raise "No gpu machine specified yet" if self.gpu_machine_id == nil
      Messaging.rasbari_cache.samosa.client(gpuMachine.hostname)
    end

  end
end
