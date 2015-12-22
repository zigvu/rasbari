require "messaging/version"

# load files based on whether it is loaded as Rails engine or not
if Module.const_defined?('Rails')
  require "messaging/engine"
else
  require "messaging/monkeypatch"
end

module Messaging
  def self.files_to_load
    lib = File::expand_path('..', __FILE__)
    templateFolders = ["#{lib}/messaging"]
    nonTemplateFolders = Dir["#{lib}/*"] - templateFolders
    nonTemplateFiles = []
    nonTemplateFolders.each do |ntf|
      # assume that all files are namespaced
      Dir["#{ntf}/**"].each do |f|
        nonTemplateFiles << File.join(File.dirname(f), File.basename(f, ".*"))
      end
    end

    nonTemplateFiles
  end

  # If using in rails context: DO NOT call this directly
  # instead use the global thread safe
  # $bunny_connection variable we get from
  # main_app/config/puma.rb
  def self.connection
    # currently assume default URL
    Connections::BunnyConnection.new(nil).connection
  end

  # TODO: move variables to config

  # Config variable for queue names that can be filled in
  mattr_accessor :video_capture_exchange
  Messaging.video_capture_exchange = "development.video.capture"

  # Memoize connection client objects
  mattr_accessor :video_capture_client
end

# load files if not used as engine
if !Module.const_defined?('Rails')
  Messaging.files_to_load.each { |file|
    require_relative file
  }
end
