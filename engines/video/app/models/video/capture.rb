module Video
  class Capture < ActiveRecord::Base

    def storageMachine
      self.storage_machine_id ? Setting::Machine.find(self.storage_machine_id) : nil
    end

    def captureMachine
      self.capture_machine_id ? Setting::Machine.find(self.capture_machine_id) : nil
    end

    def storageClient
      raise "No storage machine specified yet" if self.storage_machine_id == nil
      Messaging.rasbari_cache.storage.client(storageMachine.hostname)
    end

    def captureClient
      raise "No capture machine specified yet" if self.capture_machine_id == nil
      Messaging.rasbari_cache.video_capture.client(captureMachine.hostname)
    end

    def startedByUser
      self.started_by ? User.find(self.started_by) : nil
    end

    def stoppedByUser
      self.stopped_by ? User.find(self.stopped_by) : nil
    end

    def isStopped?
      self.stopped_at != nil
    end

    belongs_to :stream
    has_many :clips, dependent: :destroy
  end
end
