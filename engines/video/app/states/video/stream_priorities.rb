module Video
  class StreamPriorities < BaseRole::ArAccessor

    def self.priorities
      ["none", "low", "medium", "high", "immediate"]
    end
    zextend BaseRole, Video::StreamPriorities.priorities

    def initialize(stream)
      super(Video::StreamPriorities.priorities, stream, :spriority)
    end

  end
end
