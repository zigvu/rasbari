module Video
  class CaptureDecorator < Draper::Decorator
    delegate_all

    def canDelete?
      object.clips.count == 0
    end

    def hasEnded?
      object.stopped_at != nil
    end

    def hasError?
      lastClip = object.clips.last
      # if the stream has not ended and no clip has been created in last 10 minutes
      if !hasEnded? && lastClip
        return ((Time.now - lastClip.created_at)/60 > 10)
      end
      false
    end

  end
end
