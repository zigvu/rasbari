module Kheer
  class ChiaModelDecorator < Draper::Decorator
    delegate_all

    def isMajor?
      object.minor_id == 0 && object.mini_id = 0
    end
    def isMinor?
      object.minor_id != 0 && object.mini_id == 0
    end
    def isMini?
      object.mini_id != 0
    end

    def majorParent
      ChiaModel.where(major_id: object.major_id).where(minor_id: 0).where(mini_id: 0).first
    end
    def minorParent
      ChiaModel.where(major_id: object.major_id).where(minor_id: object.minor_id).where(mini_id: 0).first
    end
    def parent
      ret = nil
      if isMinor?
        ret = ChiaModel.where(major_id: object.major_id)
          .where(minor_id: (object.minor_id - 1))
          .where(mini_id: 0).first
      elsif isMini?
        ret = ChiaModel.where(major_id: object.major_id)
          .where(minor_id: object.minor_id)
          .where(mini_id: (object.mini_id - 1)).first
      end
      ret
    end

    def minors
      ChiaModel.where(major_id: object.major_id)
        .where.not(minor_id: 0)
        .where(mini_id: 0).order(minor_id: :asc)
    end
    def minis
      ChiaModel.where(major_id: object.major_id)
        .where(minor_id: object.minor_id)
        .where.not(mini_id: 0).order(mini_id: :asc)
    end

    def ancestorIds
      ancCmIds = []
      ChiaModel.where(major_id: object.major_id).each do |cm|
        ancCmIds << cm.id if (cm.minor_id <= object.minor_id && cm.mini_id <= object.mini_id)
      end
      ancCmIds - [object.id]
    end

    def version
      "#{object.major_id}.#{object.minor_id}.#{object.mini_id}"
    end

    def annotationCount
      chmIds = [object.id]
      if isMajor?
        chmIds = ChiaModel.where(major_id: object.major_id).pluck(:id)
      elsif isMinor?
        chmIds = ChiaModel.where(major_id: object.major_id).where(minor_id: object.minor_id).pluck(:id)
      end
      Annotation.in(chia_model_id: chmIds).count
    end

  end
end
