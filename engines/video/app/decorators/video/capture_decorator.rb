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

    def toMessage
      ar = object.attributes.symbolize_keys.merge({
        captureId: object.id,
        captureUrl: object.capture_url,
        playbackFrameRate: object.playback_frame_rate,
        storageHostname: object.storageMachine.hostname,
      })
      Messaging::Messages::VideoCapture::CaptureDetails.new(ar)
    end

  end
end
