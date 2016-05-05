require "thread"

module Kheer
  class LocalizationIngester
    def initialize
      Rails.logger.info("Start LocalizationIngester")
      @shouldExitMutex = Mutex.new
      setShouldExit(false)
      @ingestTempFolder = "/tmp/ingest"
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
              Rails.logger.debug("Ingest Clip Id: #{clipEval.clip_id}")
              processedInLoop = true

              # download localization to temporary path
              locFolder = "#{@ingestTempFolder}/#{capEval.id}"
              FileUtils.mkdir_p(locFolder)
              remoteFile = clipEval.localizationDataPath
              localFile = "#{locFolder}/#{File.basename(remoteFile)}"
              status, _ = capEval.storageClient.getFile(remoteFile, localFile)

              # if download successful, ingest
              if status
                cdi = ClipDataImporter.new(localFile)
                cdi.writeData
                clipEval.state.setIngested
                FileUtils.rm_rf(localFile)
                Rails.logger.debug("Ingested Clip Id: #{clipEval.clip_id}")
              else
                Rails.logger.error("Cannot download Clip Id: #{clipEval.clip_id}")
                clipEval.state.setFailed
              end
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
