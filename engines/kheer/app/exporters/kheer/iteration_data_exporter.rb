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
              # if annotation det was not selected for iteration or user did not
              # explicitely draw it, include it as avoid
              if @iteration.detectable_ids.include?(detId) && a7.sourceType.isUser?
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
      # for this model
      chiaModel = ChiaModel.find(@iteration.chia_model_id)
      config = createTrainConfig(chiaModel)
      configFile = "#{extractPath}/zigvu_config_train.json"
      saveFile(config, configFile)
      # for the parent model, with 0 iteration
      parentChiaModel = chiaModel.decorate.parent
      config = createTrainConfig(parentChiaModel, 0)
      configFile = "#{extractPath}/zigvu_config_train_parent.json"
      saveFile(config, configFile)
    end

    def createTrainConfig(chiaModel, numIter = nil)
      # should match expection of sample config from:
      # /home/ubuntu/samosa/chia/bin/zigvu/zigvu_config_train.json
      iter = chiaModel.iteration
      parentChiaModel = chiaModel.decorate.parent
      iterType = iter.type.isQuick? ? "minor" : "major"
      positiveClasses = iter.decorate.chiaToDetMapNonAvoid.values.map{ |d| d.to_s }
      avoidClasses = iter.decorate.chiaToDetMapAvoid.values.map{ |d| d.to_s }
      numIter ||= iter.num_iterations
      config = {
        mode: "train",
        output_folder: "/tmp",
        iteration_id: @iteration.id.to_s, # training iteration id is same even for parent
        chia_model_id: chiaModel.id,
        parent_chia_model_id: parentChiaModel.id,
        iteration_type: iterType,
        num_caffe_iteration: numIter,
        positive_classes: positiveClasses,
        avoid_classes: avoidClasses
      }
      config
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
