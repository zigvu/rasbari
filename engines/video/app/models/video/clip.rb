module Video
  class Clip < ActiveRecord::Base

    def state
      Video::ClipStates.new(self)
    end

    # TODO: move to storage path generator
    def path
      "#{self.capture.stream.id}/#{self.capture.id}/#{self.id}"
    end
    def clipPath
      "/data/#{self.capture.storageMachine.hostname}/#{self.path}/#{self.id}.mkv"
    end
    def thumbnailPath
      "/data/#{self.capture.storageMachine.hostname}/#{self.path}/#{self.id}.jpg"
    end

    belongs_to :capture
  end
end