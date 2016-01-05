module Video
  class ClipStates < BaseAr::ArAccessor

    def self.states
      ["created", "saved", "deleted"]
    end
    zextend BaseState, Video::ClipStates.states

    def initialize(clip)
      super(clip, :zstate)
    end

  end
end
