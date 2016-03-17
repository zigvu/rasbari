module Kheer
  module IterationWorkflow
    class SelectNumIters
      attr_accessor :iterationTypes
      attr_accessor :exhaustiveNumIter, :quickNumIter

      def initialize(iteration)
        @iteration = iteration
      end

      def canSkip
        @iteration.state.isAfterConfiguring?
      end

      def serve
        currentCm = @iteration.chia_model
        @iterationTypes = Kheer::IterationTypes.to_h
        ancCmIds = ChiaModel.where(major_id: currentCm.major_id).pluck(:id) - [currentCm.id]

        curAnnos = Annotation.where(chia_model_id: currentCm.id).pluck(:cl, :fn).group_by{|a| a[0]}
        curAnnosFrames = 0
        curAnnos.each do |clipId, clFn|
          curAnnosFrames += clFn.map{ |c| c[1]}.uniq.count
        end

        totAnnos = Annotation.in(chia_model_id: ancCmIds).pluck(:cl, :fn).group_by{|a| a[0]}
        totAnnosFrames = 0
        totAnnos.each do |clipId, clFn|
          totAnnosFrames += clFn.map{ |c| c[1]}.uniq.count
        end

        @exhaustiveNumIter = (totAnnosFrames + curAnnosFrames) * 15
        @quickNumIter = totAnnosFrames * 5 + curAnnosFrames * 15
      end

      def handle(params)
        trace = "Done"
        iterationType = params["ztype"]
        numIterations = params["num_iterations"].to_i
        status = @iteration.update({
          ztype: iterationType,
          num_iterations: numIterations
        })
        return status, trace
      end

    end
  end
end
