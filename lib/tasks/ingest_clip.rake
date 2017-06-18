require 'fileutils'
require 'yaml'
require 'open3'


namespace :ingest_clip do

# rake ingest_clip:ingest stream_id=<ID> clip_file=<clip_file_location>

  def fail_on_error(wait_thr, cmd)
    exit_status = wait_thr.value
    unless exit_status.success?
      abort "Failed !!! #{cmd}"
    end
  end


  def execute_cmd ( cmd)
    puts("EXEC: #{cmd}")
    Open3.popen3( cmd) do | stdin, stdout, stderr, wait_thr |
      while line = stdout.gets
        puts line
      end
    end
  end
  def execute_and_read( cmd) 
    puts("EXEC: #{cmd}")
    ret = ''
    Open3.popen3( cmd) do | stdin, stdout, stderr, wait_thr |
      while line = stdout.gets
        ret += line
      end
    end
    ret
  end

  def clip_info( clip_file)
    op_str = execute_and_read( "ffprobe -v quiet -print_format json  -show_streams #{clip_file}")
    jsObj  = JSON.parse( op_str)
    streams = jsObj['streams']

    info = Hash.new
    streams.each { |strm_obj|
      strm_obj.each { |k,v| info[k] = v }
    }
    info
  end

  def buildTar(data_folder, tarname)
    puts("Data: #{data_folder} Tar: #{tarname}")
    Dir.chdir( data_folder) do
      tar_cmd = "tar -zcvf #{tarname} *"
      execute_cmd tar_cmd
    end
    tarname
  end


  desc "Setup the stream id and video folder file"
  task setup: :environment do 
    @is_production =  "production" == ENV["RENV"]
    @stream_id = ENV['stream_id'] 
    @clip_file = ENV['clip_file']

    @storage_machine_id = 1
    @capture_machine_id = 2
    @gpu_machind_id =3

    puts "Stream #{@stream_id} Clip: #{@clip_file}"
    if @stream_id.nil? || @clip_file.nil?
      abort "Both stream_id and clip_file must be defined environment variables"
    end

    if ! File.exists? @clip_file
      abort "Can not find or access the file #(@clip_file)"
    end
    @clip_dir = File.dirname( @clip_file)
    @file_name = File.basename( @clip_file, ".*")
    @tmp_folder_root = "/tmp/task_process" #{Process.pid}

  end

  def buildCaptureModel(streamModel, clip_dim)
    captureModel = Video::Capture.create()
    captureModel.stream = streamModel
    captureModel.storage_machine_id = @storage_machine_id
    captureModel.capture_machine_id = @capture_machine_id
    captureModel.width = clip_dim['width']
    captureModel.height = clip_dim['height']
    captureModel.save
    captureModel
  end

  def buildClip( captureModel)
    clip = Video::Clip.create()
    clip.capture = captureModel
    clip.length = 60000 # 60 * 1000
    clip.frame_number_start = 0
    clip.frame_number_end = 1500 # 25 * 60
    clip.save
    clip
  end

  def generateClips(tmp_folder)
    cmd_gen_clip = "ffmpeg -loglevel error   -i #{@clip_file} -c:v libx264 -pix_fmt yuv420p " \
                   "-crf 20 -preset veryfast -f segment -segment_time 60 -reset_timestamps 1 " \
                   "-strict -2 -r  25 #{tmp_folder}/%04d.mp4"

    puts cmd_gen_clip


    FileUtils.mkdir_p tmp_folder
    Open3.popen3( cmd_gen_clip) do | stdin, stdout, stderr, wait_thr |
      fail_on_error( wait_thr, cmd_gen_clip)
    end
  end

  #============================================================

  desc "convert the video file to the clips"
  task :ingest => [ :setup ] do
    begin
      puts "Injest: stream_id: #{@stream_id} clip_file: #{@clip_file} clip_dir: #{@clip_dir}"

      streamModel = Video::Stream.find( @stream_id)
      puts "STREAM:  \n#{streamModel.inspect}"
      clip_dim = clip_info( @clip_file)
      captureModel = buildCaptureModel( streamModel, clip_dim)
      puts "CAPTURE: \n#{captureModel.inspect}"


      storageMachine = Setting::Machine.find( captureModel.storage_machine_id)
      storageClient = Messaging.rasbari_cache.storage.client(storageMachine.hostname)
      serverFilePath = "/data/#{storageMachine.hostname}"
      status, trace = storageClient.isRemoteAlive?

      puts("Status #{status} Trace #{trace} serverFilePath #{serverFilePath}")

      data_folder ="#{@tmp_folder_root}/data" 
      rel_CaptureFolder = "streams/#{@stream_id}/#{captureModel.id}"
      tmp_folder = "#{data_folder}/#{rel_CaptureFolder}"
      FileUtils.mkdir_p tmp_folder


      if File.exists? tmp_folder
        FileUtils.rm_r tmp_folder
      end

      generateClips(tmp_folder)

      clipFiles = Dir[tmp_folder +"/*.mp4"].sort
      clipFiles.each do |f| 
        base_file_name = File.basename(f, File.extname(f))
        clip = buildClip( captureModel)

        rel_ClipFolder      = "#{rel_CaptureFolder}/#{clip.id.to_s}"
        serverClipFolder    = "#{serverFilePath}/#{rel_ClipFolder}"
        serverClipPath      = "#{serverClipFolder}/#{clip.id.to_s}#{File.extname(f)}"
        serverThumbnailPath = "#{serverClipFolder}/#{clip.id.to_s}.jpg"

        puts "CLIP: \n#{clip.inspect} #{clip.id}"
        
        clip_folder = @is_production ? "#{tmp_folder}/#{clip.id.to_s}" :  serverClipFolder
        new_clip = "#{clip_folder}/#{clip.id.to_s}"


        FileUtils.mkdir_p clip_folder
        new_clip_name = "#{new_clip}#{File.extname(f)}"
        thumb_nail_file = "#{new_clip}.jpg"
        puts("new clip name #{new_clip_name} thumb namil #{thumb_nail_file}")
        FileUtils.mv( f, new_clip_name)

        
        status, trace = storageClient.saveFile( new_clip_name, serverClipPath )
        puts("Status send #{status} #{trace} for #{new_clip_name} TO: #{serverClipPath}")

        thumbnail_cmd = "ffmpeg -y -i #{new_clip_name} -f mjpeg -vframes 1 #{thumb_nail_file}"
        execute_cmd thumbnail_cmd

        status, trace = storageClient.saveFile( thumb_nail_file, serverThumbnailPath )
        puts("Status send #{status} #{trace} for #{thumb_nail_file} TO: #{serverThumbnailPath}")
      end

      # tar_file = buildTar(data_folder, "#{tar_folder}/build_inputs.tar.gz")
      # status, trace = storageClient.saveFile( tar_file, "#{serverFilePath}/build_inputs.tar.gz")
      # puts("send #{data_folder} to #{serverFilePath}")
      # status, trace = storageClient.saveFile( data_folder, serverFilePath)
      # puts "File send status #{status} #{trace}"
      storageClient.closeConnection
    ensure
      Rake::Task["ingest_clip:cleanup"].execute
    end
  end

  task :cleanup do
    FileUtils.rm_r @tmp_folder_root
    if @is_production
      
    end
  end

end



