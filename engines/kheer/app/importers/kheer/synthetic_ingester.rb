require "thread"

module Kheer
  class SyntheticIngester
    def initialize(inputFolder, streamId, chiaVersion, outFolder)
      Rails.logger.info("Start SyntheticIngester")
      @inputFolder = inputFolder
      @stream = Video::Stream.find(streamId)
      @chiaModelId = Kheer::ChiaModel.fromVersion(chiaVersion).id
      @outFolder = outFolder
      FileUtils.mkdir_p(@outFolder)

      @dumper = Kheer::GenericDumper.new('Kheer::Annotation')
    end

    def run
      readFiles
      createCapture
      @clipsAnnosFile.each do |clipPath, annoPath|
        ingestClip(clipPath, annoPath)
      end
      @dumper.finalize
    end

    def readFiles
      @clipsAnnosFile = []
      clips = Dir.glob("#{@inputFolder}/clips/*.mp4").sort_by{ |fn|
        File.basename(fn, ".*").to_i
      }
      annos = Dir.glob("#{@inputFolder}/annotations/*.json").sort_by{ |fn|
        File.basename(fn, ".*").to_i
      }

      # ensure that all clips have corresponding annotations
      raise "Unequal num of clips and annos" if clips.count != annos.count
      clips.each do |clip|
        clipNum = File.basename(clip, ".*").to_i
        found = false
        annos.each do |anno|
          if File.basename(clip, ".*").to_i == clipNum
            @clipsAnnosFile << [clip, anno]
            found = true
            break
          end
        end
        raise "Annotation not found for clip: #{clip}" if !found
      end
      @clipsAnnosFile
    end

    def createCapture
      storageMachine = Setting::Machine.where(ztype: Setting::MachineTypes.storage).first
      captureMachine = Setting::Machine.where(ztype: Setting::MachineTypes.capture).first
      gpuMachine = Setting::Machine.where(ztype: Setting::MachineTypes.gpu).first
      @capture = @stream.captures.create(
        storage_machine_id: storageMachine.id,
        capture_machine_id: captureMachine.id,
        capture_url: "synthetic.zigvu.com",
        comment: "Synthetic clips",
        width: 1280,
        height: 720,
        playback_frame_rate: 25.0,
        started_by: 1,
        stopped_by: 1,
        started_at: DateTime.now,
        stopped_at: DateTime.now,
        detection_frame_rate: 5.0,
        name: "Synthetic clips - #{DateTime.now}"
      )
      # simulate that this capture is evaluated
      Kheer::CaptureEvaluation.create(
        capture_id: @capture.id,
        chia_model_id: @chiaModelId,
        user_id: 1,
        gpu_machine_id: gpuMachine.id,
        zstate: Kheer::CaptureEvaluationStates.evaluated
      )
      @capturePath = "#{@outFolder}/#{@stream.id}/#{@capture.id}"
      FileUtils.mkdir_p(@capturePath)
      Rails.logger.info("Created a new capture (id: #{@capture.id}) to ingest clips")
    end

    def ingestClip(clipPath, annoPath)
      Rails.logger.info("Ingesting clip: #{clipPath}")
      clip = createClip(clipPath)
      ingestAnnos(annoPath, clip)
    end

    def ingestAnnos(annoPath, clip)
      annoList = JSON.load(File.open(annoPath))
      annoList.each do |fn, annos|
        annos["embedded_dets"].each do |detFile, rects|
          detId = detFile.split("/")[-2]
          rects.each do |rect|
            addAnno(clip.id, fn, detId, rect["anno_rect"])
          end
        end
      end
      # flush after each clip
      @dumper.flush
    end

    def createClip(clipPath)
      clip = @capture.clips.create(
        zstate: "saved",
        length: 41120,
        frame_number_start: 0,
        frame_number_end: 1027
      )
      newClipFolder = "#{@capturePath}/#{clip.id}"
      FileUtils.mkdir_p(newClipFolder)
      FileUtils.cp(clipPath, "#{newClipFolder}/#{clip.id}.mp4")
      clip
    end

    def addAnno(clipId, fn, detId, rect)
      @dumper.add({
        ci: @chiaModelId,
        cl: clipId,
        fn: fn.to_i,
        at: true,
        sct: "user",
        sci: "1",
        di: detId.to_i,
        x0: rect["x0"].to_i, y0: rect["y0"].to_i,
        x1: rect["x1"].to_i, y1: rect["y1"].to_i,
        x2: rect["x2"].to_i, y2: rect["y2"].to_i,
        x3: rect["x3"].to_i, y3: rect["y3"].to_i
      })
    end

  end
end
