module Video
  class StreamPriorities < BaseAr::ArAccessor

    def self.priorities
      ["none", "low", "medium", "high", "immediate"]
    end
    zextend BaseRole, Video::StreamPriorities.priorities

    def initialize(stream)
      super(stream, :spriority)
    end

  end
end
