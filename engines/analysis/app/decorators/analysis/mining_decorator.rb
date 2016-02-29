module Analysis
  class MiningDecorator < Draper::Decorator
    delegate_all

    def chiaModelLoc
      return "" if self.chia_model_id_loc == nil
      cm = Kheer::ChiaModel.find(self.chia_model_id_loc)
      return "#{cm.id} (#{cm.name})"
    end

    def chiaModelAnno
      return "" if self.chia_model_id_loc == nil
      cm = Kheer::ChiaModel.find(self.chia_model_id_anno)
      return "#{cm.id} (#{cm.name})"
    end


  end
end
