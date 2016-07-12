require 'fileutils'
require 'yaml'

namespace :import do

  desc "Import synthetic clip and annotations"
  task synthetic: :environment do
    input_folder = ENV['input_folder']
    stream_id = ENV['stream_id']
    chia_version = ENV['chia_version']
    output_folder = ENV['output_folder']
    if (input_folder == nil || stream_id == nil || chia_version == nil || output_folder == nil)
      puts "Usage: rake import:synthetic input_folder=<folder> stream_id=<id> chia_version=<chaiVersion> output_folder=<folder>"
      puts "Note: <chaiVersion> needs to be in correct format. Example: 1.1.2"
    else
      FileUtils.rm_rf(output_folder)
      FileUtils.mkdir_p(output_folder)
      si = Kheer::SyntheticIngester.new(input_folder, stream_id.to_i, chia_version, output_folder)
      si.run

      puts "\n\n"
      puts "Please copy files from #{output_folder} to storage server"
      puts "Location in output path as: "
      puts "#{output_folder}/<streamId>/<captureId>/<clipId>/<clipId.mp4>"
      puts "Location in storage server as: "
      puts "ubuntu@azvm4:/data/azvm4/streams/<streamId>/<captureId>/<clipId>/<clipId.mp4>"
    end
  end

  desc "Import clips"
  task clips: :environment do
    input_folder = ENV['input_folder']
    stream_id = ENV['stream_id']
    output_folder = ENV['output_folder']
    if (input_folder == nil || stream_id == nil || output_folder == nil)
      puts "Usage: rake import:clips input_folder=<folder> stream_id=<id> output_folder=<folder>"
    else
      FileUtils.rm_rf(output_folder)
      FileUtils.mkdir_p(output_folder)

      # since we reuse Kheer::SyntheticIngester, create dummy annotation files
      importFolder = "/tmp/import_#{rand(1000)}_clips"
      FileUtils.rm_rf(importFolder)
      clipsFolder = "#{importFolder}/clips"
      annosFolder = "#{importFolder}/annotations"
      FileUtils.mkdir_p(clipsFolder)
      FileUtils.mkdir_p(annosFolder)

      Dir.glob("#{input_folder}/*.mp4").each do |clipFile|
        FileUtils.ln_sf(clipFile, clipsFolder)
        annoFnBase = File.basename(clipFile, ".*")
        File.open("#{annosFolder}/#{annoFnBase}.json", "w") do |f|
          f.puts "{}"
        end
      end

      si = Kheer::SyntheticIngester.new(importFolder, stream_id.to_i, "1", output_folder)
      si.run

      puts "\n\n"
      puts "Please copy files from #{output_folder} to storage server"
      puts "Location in output path as: "
      puts "#{output_folder}/<streamId>/<captureId>/<clipId>/<clipId.mp4>"
      puts "Location in storage server as: "
      puts "ubuntu@azvm4:/data/azvm4/streams/<streamId>/<captureId>/<clipId>/<clipId.mp4>"

      FileUtils.rm_rf(importFolder)
    end
  end

end
