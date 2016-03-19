module Kheer
  module ExportFormatters
    class AnnotationFormatter

      attr_accessor :annoFilename

      def initialize(clipId, frameNumber)
        @clipId = clipId
        @frameNumber = frameNumber
        @isMinor = false
        @annoFilename = "#{@frameNumber}.json"

        @annotations = {}
      end

      def setMinor
        @isMinor = true
      end

      def getFormatted
        # Note: this is tied to JSON expectation of Chia python scripts
        return {
          clip_id: @clipId,
          frame_number: @frameNumber,
          is_minor: @isMinor,
          annotations: @annotations
        }
      end

      def getDetIds
        @annotations.keys
      end

      def addAnnotation(cls, anno)
        if @annotations[cls] == nil
          @annotations[cls] = []
        end

        @annotations[cls] += [getFormattedAnno(anno)]
      end

      def getFormattedAnno(anno)
        return {
          annotation_id: anno.id.to_s,

          x0: anno.x0,
          y0: anno.y0,

          x1: anno.x1,
          y1: anno.y1,

          x2: anno.x2,
          y2: anno.y2,

          x3: anno.x3,
          y3: anno.y3
        }
      end

    end
  end
end
