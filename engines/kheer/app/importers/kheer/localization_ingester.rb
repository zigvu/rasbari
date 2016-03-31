require "thread"

module Kheer
  class LocalizationIngester
    def initialize
      Rails.logger.info("Start LocalizationIngester")
      @shouldExitMutex = Mutex.new
      setShouldExit(false)
    end

    def run
      @thread = Thread.new{ ingest }
    end

    def join
      setShouldExit
      @thread.join
    end

    private
      def setShouldExit(se = true)
        @shouldExitMutex.synchronize { @shouldExit = se }
      end
      def shouldExit?
        @shouldExit
      end

      def ingest
        while true do
          processedInLoop = false
          CaptureEvaluation.where(zstate: CaptureEvaluationStates.evaluating).each do |capEval|
            # ingest evaluated clips
            capEval.clip_evaluations.where(zstate: ClipEvaluationStates.evaluated).each do |clipEval|
              processedInLoop = true
              cdi = ClipDataImporter.new(clipEval.localizationDataPath)
              cdi.writeData
              clipEval.state.setIngested
              break if shouldExit?
            end
            # check if all clips have been ingested
            totClipEvals = capEval.clip_evaluations.count
            totCompletedClipEvals = capEval.clip_evaluations.in(zstate: [
              ClipEvaluationStates.ingested, ClipEvaluationStates.failed
            ]).count
            if totClipEvals == totCompletedClipEvals
              capEval.state.setEvaluated
            end
            break if shouldExit?
          end

          # if no processing was done, sleep
          sleep(30) if !processedInLoop && !shouldExit?
          break if shouldExit?
        end
      end
    # end private
  end
end
