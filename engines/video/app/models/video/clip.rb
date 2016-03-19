module Video
  class Clip < ActiveRecord::Base

    def state
      Video::ClipStates.new(self)
    end

    # TODO: move to storage path generator
    def path
      "streams/#{self.capture.stream.id}/#{self.capture.id}/#{self.id}"
    end
    def clipPath
      "/data/#{self.capture.storageMachine.hostname}/#{self.path}/#{self.id}.mp4"
    end
    def thumbnailPath
      "/data/#{self.capture.storageMachine.hostname}/#{self.path}/#{self.id}.jpg"
    end

    belongs_to :capture
  end
end
