module Analysis
  module ConfusionFinderWorkflow
    class SetClips
      # TODO: change once we have better way of handling continuous run clips
      attr_reader :streams, :selectedStreamIds

      def initialize(mining)
        @mining = mining
      end

      def canSkip
        false
      end

      def serve
        @streams = Video::Stream.all
        @selectedStreamIds = @mining.stream_ids || []
      end

      def handle(params)
        streamIds = params["stream_ids"].map{ |s| s.to_i }
        clipIds = []
        streamIds.each do |streamId|
          clipIds += Video::Stream.find(streamId).clips.pluck(:id)
        end
        trace = "Done"
        status = @mining.update({
          stream_ids: streamIds,
          clip_ids: clipIds.sort
        })

        return status, trace
      end

    end
  end
end
