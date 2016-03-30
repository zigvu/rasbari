require 'fileutils'
require 'json'

module Kheer
  class CaptureEvaluationExporter
    attr_accessor :tarFile

    def initialize(capture_evaluation)
      @capture_evaluation = capture_evaluation
      @basePath = "/tmp/capture_evaluation/#{@capture_evaluation.id}"
      @tarFile = "#{@basePath}/test_input.tar.gz"
    end

    def extract
      FileUtils.rm_rf(@basePath)
      extractPath = "#{@basePath}/files"
      FileUtils.mkdir_p(extractPath)

      saveKhajuriConfig(extractPath)

      saveFilesToTar(extractPath, @tarFile)
      true
    end

    def saveKhajuriConfig(extractPath)
      # should match expection of sample config from:
      # /home/ubuntu/samosa/chia/bin/zigvu/zigvu_config_test.json
      chiaModel = @capture_evaluation.chia_model
      iteration = chiaModel.iteration
      positiveClasses = []
      avoidClasses = []
      Detectable.where(id: iteration.detectable_ids).each do |det|
        # treat both positive and negative classes as non-avoid
        det.type.isAvoid? ? avoidClasses << det.id.to_s : positiveClasses << det.id.to_s
      end
      config = {
        mode: "test",
        chia_model_id: chiaModel.id,
        positive_classes: positiveClasses,
        avoid_classes: avoidClasses
      }
      configFile = "#{extractPath}/zigvu_config_test.json"
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
