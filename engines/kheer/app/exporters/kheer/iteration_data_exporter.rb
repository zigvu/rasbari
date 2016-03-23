require 'fileutils'
require 'json'

module Kheer
  class IterationDataExporter
    attr_accessor :tarFile

    def initialize(iteration)
      @iteration = iteration
      @basePath = "/tmp/iterations/#{@iteration.id}"
      @tarFile = "#{@basePath}/build_inputs.tar.gz"
    end

    def extract
      FileUtils.rm_rf(@basePath)
      extractPath = "#{@basePath}/files"
      FileUtils.mkdir_p(extractPath)

      saveChiaTrainConfig(extractPath)
      saveAnnotations(extractPath)

      saveFilesToTar(extractPath, @tarFile)
      true
    end

    def saveAnnotations(extractPath)
      annosBasePath = "#{extractPath}/build_data"
      allClipIds = []

      currentCm = @iteration.chia_model
      avoidDetId = Detectable.where(id: currentCm.detectable_ids)
          .where(ztype: Kheer::DetectableTypes.avoid)
          .first.id
      allCmIds = ChiaModel.where(major_id: currentCm.major_id).pluck(:id)

      Annotation.in(chia_model_id: allCmIds).where(active: true)
        .order(frame_number: :asc)
        .group_by{|a1| a1.clip_id}.each do |clipId, a2|

        # account for corrupted annotations
        next if clipId == nil
        allClipIds << clipId if not allClipIds.include?(clipId)

        clipAnnoOutFolder = "#{annosBasePath}/#{clipId}/annotations"
        FileUtils::mkdir_p(clipAnnoOutFolder)
        frameIds = []
        frameIdsFilename = "#{annosBasePath}/#{clipId}/frame_numbers.txt"

        a2.group_by{|a3| a3.frame_number}.each do |clipFrameNumber, a4|
          annoCmIds = []
          annoFormatter = Kheer::ExportFormatters::AnnotationFormatter.new(
            clipId, clipFrameNumber)
          a4.group_by{|a5| a5.detectable_id}.each do |detId, a6|
            a6.each do |a7|
              annoCmIds << a7.chia_model_id
              # if annotation det was not selected for iteration, include it as avoid
              if @iteration.detectable_ids.include?(detId)
                annoFormatter.addAnnotation(detId, a7)
              else
                annoFormatter.addAnnotation(avoidDetId, a7)
              end
            end
          end
          # if no annotations belong to current chia model, can set to minor
          if @iteration.type.isQuick? && !annoCmIds.include?(currentCm.id)
            annoFormatter.setMinor
          end
          # skip if only avoid labels
          next if (annoFormatter.getDetIds - [avoidDetId]).count == 0
          # save file
          saveFile(annoFormatter.getFormatted(), "#{clipAnnoOutFolder}/#{annoFormatter.annoFilename}")
          frameIds << clipFrameNumber
        end
        File.open(frameIdsFilename, "w") do |f|
          f.write(frameIds.to_s[1..-2].gsub(/,/, '') + "\n")
        end
      end
      clipIdsFile = "#{extractPath}/clip_ids.json"
      saveFile(allClipIds.uniq.sort, clipIdsFile)
    end

    def saveChiaTrainConfig(extractPath)
      # should match expection of sample config from:
      # /home/ubuntu/samosa/chia/bin/zigvu/zigvu_config_train.json
      parentChiaModel = ChiaModel.find(@iteration.chia_model_id).decorate.parent
      iterationType = @iteration.type.isQuick? ? "minor" : "major"
      positiveClasses = []
      avoidClasses = []
      Detectable.where(id: @iteration.detectable_ids).each do |det|
        # treat both positive and negative classes as non-avoid
        det.type.isAvoid? ? avoidClasses << det.id.to_s : positiveClasses << det.id.to_s
      end
      config = {
        mode: "train",
        output_folder: "/tmp",
        iteration_id: @iteration.id.to_s,
        chia_model_id: @iteration.chia_model_id,
        parent_chia_model_id: parentChiaModel.id,
        iteration_type: iterationType,
        num_caffe_iteration: @iteration.num_iterations,
        gpu_device_id: 0,
        positive_classes: positiveClasses,
        avoid_classes: avoidClasses
      }
      configFile = "#{extractPath}/zigvu_config_train.json"
      saveFile(config, configFile)
    end

    def saveFilesToTar(extractPath, tarFile)
      Dir.chdir(extractPath) do
        `tar -zcvf #{tarFile} *`
      end
    end

    def saveFile(fileHash, filename)
      File.open(filename, 'w') do |f|
        f.write(JSON.pretty_generate(fileHash))
      end
    end

    def cleanup
      FileUtils.rm_rf(@basePath)
    end

  end
end
