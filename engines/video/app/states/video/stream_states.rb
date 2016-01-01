module Video
  class StreamStates < BaseAr::ArAccessor

    def self.states
      ["ready", "settingUp", "capturing", "failed", "stopped"]
    end
    zextend BaseState, Video::StreamStates.states

    def initialize(stream)
      super(stream, :zstate)
    end

  end
end
