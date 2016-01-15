module Video
  class StreamDecorator < Draper::Decorator
    delegate_all

    def hasError?
      # if the stream is capturing but no clip has been created in last 10 minutes
      if object.state.isCapturing? && lastClip
        return ((Time.now - lastClip.created_at)/60 > 10)
      end
      false
    end

    def lastClip
      # if there is an ongoing capture, supply active clip, else stopped clip
      object.captures.where(stopped_at: nil).count > 0 ? activeLastClip : stoppedLastClip
    end

    def activeLastClip
      lastCapture = object.captures.where(stopped_at: nil).order(created_at: :desc).last
      lastCapture.clips.last if lastCapture
    end
    def stoppedLastClip
      lastCapture = object.captures.where.not(stopped_at: nil).order(stopped_at: :desc).last
      lastCapture.clips.last if lastCapture
    end

  end
end
