module Analysis
  module DetFinderWorkflow
    class SetClips
      # TODO: change once we have better way of handling continuous run clips
      attr_reader :formattedCaptures

      def initialize(mining)
        @mining = mining
      end

      def canSkip
        false
      end

      def serve
        # only evaluated captures need to be selected
        captureIds = Kheer::CaptureEvaluation
          .where(ci: @mining.chia_model_id_loc)
          .pluck(:capture_id)
        selectedCaptureIds = @mining.capture_ids || []

        # format:
        # {stream: [capture, ]}
        streams = {}
        captures = Video::Capture.where(id: captureIds)
        captures.each do |capture|
          streams[capture.stream] ||= []
          streams[capture.stream] << capture
        end

        # format
        # [{idx:, captureId:, captureName:, streamName:, isSelected:}, ]
        @formattedCaptures = []
        idx = 0
        streams.each do |stream, streamCaps|
          streamCaps.each do |capture|
            idx += 1
            @formattedCaptures << {
              idx: idx, captureId: capture.id, captureName: capture.name,
              streamName: stream.name,
              isSelected: selectedCaptureIds.include?(capture.id)
            }
          end
        end
      end

      def handle(params)
        captureIds = params["capture_ids"].map{ |c| c.to_i }
        clipIds = []
        captureIds.each do |captureId|
          clipIds += Video::Capture.find(captureId).clips.pluck(:id)
        end
        trace = "Done"
        status = @mining.update({
          capture_ids: captureIds,
          clip_ids: clipIds.sort
        })

        return status, trace
      end

    end
  end
end
