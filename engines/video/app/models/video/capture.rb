module Video
  class Capture < ActiveRecord::Base

    def storageMachine
      self.storage_machine_id ? Setting::Machine.find(self.storage_machine_id) : nil
    end

    def captureMachine
      self.capture_machine_id ? Setting::Machine.find(self.capture_machine_id) : nil
    end

    def storageClient
      # TODO: get client
      nil
    end

    def captureClient
      raise "No capture machine specified yet" if self.capture_machine_id == nil
      Messaging.rasbari_cache.video_capture.client(captureMachine.hostname)
    end

    def toMessage
      ar = self.attributes.symbolize_keys.merge({
        captureId: self.id,
        captureUrl: self.capture_url,
        playbackFrameRate: self.playback_frame_rate,
        storageHostname: self.storageMachine.hostname,
      })
      Messaging::Messages::VideoCapture::CaptureDetails.new(ar)
    end

    belongs_to :stream
    has_many :clips, dependent: :destroy
  end
end
