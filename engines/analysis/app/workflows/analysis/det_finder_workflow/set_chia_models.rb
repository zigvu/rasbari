module Analysis
  module DetFinderWorkflow
    class SetChiaModels
      attr_reader :chiaModelsHierarchy
      attr_reader :selectedMajorLocId, :selectedMinorLocId, :selectedMiniLocId
      attr_reader :selectedMajorAnnoId, :selectedMinorAnnoId, :selectedMiniAnnoId

      def initialize(mining)
        @mining = mining
      end

      def canSkip
        false
      end

      def serve
        @chiaModelsHierarchy = Kheer::ChiaModel.hierarchy
        @selectedMiniLocId = @mining.chia_model_id_loc
        if @mining.chia_model_id_loc
          @selectedMiniLoc = Kheer::ChiaModel.find(@selectedMiniLocId)
          @selectedMinorLocId = @selectedMiniLoc.decorate.minorParent.id
          @selectedMajorLocId = @selectedMiniLoc.decorate.majorParent.id
        end
        @selectedMiniAnnoId = @mining.chia_model_id_anno
        if @selectedMiniAnnoId
          @selectedMiniAnno = Kheer::ChiaModel.find(@selectedMiniAnnoId)
          @selectedMinorAnnoId = @selectedMiniAnno.decorate.minorParent.id
          @selectedMajorAnnoId = @selectedMiniAnno.decorate.majorParent.id
        end
      end

      def handle(params)
        trace = "Done"
        cmIdLoc = params['chia_model_id_loc']
        cmIdAnno = params['chia_model_id_anno']
        if cmIdLoc == nil || cmIdAnno == nil
          trace = "Cannot set chia models - ensure that mini versions are chosen"
          status = false
        else
          status = @mining.update({
            chia_model_id_loc: cmIdLoc.to_i,
            chia_model_id_anno: cmIdAnno.to_i
          })
        end
        return status, trace
      end

    end
  end
end
