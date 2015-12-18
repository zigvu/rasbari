module Video
  class StreamTypes < BaseType::ArAccessor

    def self.types
      ["youtube", "webBroadcast", "tvBroadcast", "oneOff", "other"]
    end
    zextend BaseType, Video::StreamTypes.types

    def initialize(stream)
      super(Video::StreamTypes.types, stream, :stype)
    end

  end
end
