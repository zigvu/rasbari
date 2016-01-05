module Video
  class StreamStates < BaseAr::ArAccessor

    def self.states
      # Also related:
      # Messaging::States::VideoCapture::CaptureStates.states
      ["configuring", "configured", "ready", "capturing", "failed", "stopped"]
    end
    zextend BaseState, Video::StreamStates.states

    def initialize(stream)
      super(stream, :zstate)
    end

  end
end
