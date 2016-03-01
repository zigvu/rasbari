module Analysis
  class MiningDecorator < Draper::Decorator
    delegate_all

    def chiaModelVersionLoc
      cmVersion(self.chia_model_id_loc)
    end
    def chiaModelVersionAnno
      cmVersion(self.chia_model_id_anno)
    end
    def cmVersion(cmId)
      return "" if cmId == nil
      cm = Kheer::ChiaModel.find(cmId)
      return "#{cm.decorate.version} (#{cm.name})"
    end


  end
end
