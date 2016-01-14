module Video
  class CaptureDecorator < Draper::Decorator
    delegate_all

    def canDelete?
      object.clips.count == 0
    end

  end
end
