module Video
  class StreamDecorator < Draper::Decorator
    delegate_all

    def lastClip
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
