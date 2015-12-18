module Video
  class StreamStates < BaseState::ArAccessor

    def self.states
      ["ready", "settingUp", "capturing", "failed", "stopped"]
    end
    zextend BaseState, Video::StreamStates.states

    def initialize(stream)
      super(Video::StreamStates.states, stream, :sstate)
    end

  end
end
