module Kheer
  class Iteration
    include Mongoid::Document
    include Mongoid::Timestamps::Created

    # meta data for indexing
    # -------------------------------------------
    field :ci, as: :chia_model_id, type: Integer
    field :dis, as: :detectable_ids, type: Array
    field :ui, as: :user_id, type: Integer
    field :bfn, as: :build_model_filename, type: String

    field :num, as: :num_iterations, type: Integer
    field :gid, as: :gpu_machine_id, type: Integer
    field :sid, as: :storage_machine_id, type: Integer

    field :st, as: :zstate, type: String
    field :tp, as: :ztype, type: String

    # index for faster traversal during ordering
    # -------------------------------------------
    index({ chia_model_id: 1 }, { background: true })

    # convenience methods
    # -------------------------------------------
    def state
      Kheer::IterationStates.new(self)
    end

    def type
      Kheer::IterationTypes.new(self)
    end

    def detectables
      return Detectable.find(self.detectable_ids)
    end

    def chia_model
      return ChiaModel.find(self.chia_model_id)
    end

    def builtParentIteration
      cmd = chia_model.decorate
      iter = nil
      if cmd.isMini?
        # for mini iteration, parent iteration is that of its parent chia model
        pIter = cmd.parent.iteration
        iter = cmd.parent.decorate.isMinor? ? pIter.builtParentIteration : pIter
      elsif cmd.isMinor?
        # for minor iteration, parent is any mini child that is built if exists
        # else, it is its parent
        lastBm = cmd.builtMinis.last
        iter = lastBm ? lastBm.iteration : cmd.parent.iteration.builtParentIteration
      elsif cmd.isMajor?
        # for major iteration, refer to first model with imagenet parent
        iter = ChiaModel.find(1).iteration
      end
      iter
    end

    def storageMachine
      self.storage_machine_id ? Setting::Machine.find(self.storage_machine_id) : nil
    end
    def gpuMachine
      self.gpu_machine_id ? Setting::Machine.find(self.gpu_machine_id) : nil
    end

    def storageClient
      raise "No storage machine specified yet" if self.storage_machine_id == nil
      Messaging.rasbari_cache.storage.client(storageMachine.hostname)
    end
    def samosaClient
      raise "No gpu machine specified yet" if self.gpu_machine_id == nil
      Messaging.rasbari_cache.samosa.client(gpuMachine.hostname)
    end

    # TODO: move to storage path generator
    def path
      "chia_models/#{self.chia_model_id}"
    end
    def modelPath
      "/data/#{self.storageMachine.hostname}/#{self.path}/#{self.build_model_filename}"
    end
    def parentModelPath
      builtParentIteration.modelPath
    end
    def buildInputPath
      "/data/#{self.storageMachine.hostname}/#{self.path}/build_inputs.tar.gz"
    end
  end
end
