module Kheer
  class ChiaModelDecorator < Draper::Decorator
    delegate_all

    def isMajor?
      object.minor_id == 0
    end
    def majorParent
      ChiaModel.where(major_id: object.major_id).where(minor_id: 0).first
    end
    def minorParent
      ChiaModel.where(major_id: object.major_id).where(minor_id: (object.minor_id - 1)).first
    end
    def minorChildren
      ChiaModel.where(major_id: object.major_id).order(minor_id: :asc) - [object]
    end
    def version
      "#{object.major_id}.#{object.minor_id}"
    end

    def annotationCount
      chmIds = [object.id]
      chmIds = minorChildren.map{ |chm| chm.id } if isMajor?
      Annotation.in(chia_model_id: chmIds).count
    end

  end
end
