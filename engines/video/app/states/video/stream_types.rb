module Video
  class StreamTypes < BaseAr::ArAccessor

    def self.types
      ["youtube", "webBroadcast", "tvBroadcast", "oneOff", "other"]
    end
    zextend BaseType, Video::StreamTypes.types

    def initialize(stream)
      super(stream, :ztype)
    end

  end
end
