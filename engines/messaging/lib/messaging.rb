require "bunny"
require "messaging/engine"

module Messaging
  class << self
    def files_to_load
      app = File::expand_path('../../app', __FILE__)
      templateFolders = ["#{app}/assets", "#{app}/controllers", "#{app}/models", "#{app}/views"]
      nonTemplateFolders = Dir["#{app}/*"] - templateFolders
      nonTemplateFiles = []
      nonTemplateFolders.each do |ntf|
        # assume that all files are namespaced
        Dir["#{ntf}/*/**"].each do |f|
          nonTemplateFiles << File.join(File.dirname(f), File.basename(f, ".*"))
        end
      end

      nonTemplateFiles
    end

    # DO NOT call this directly - instead use the global thread safe
    # $bunny_connection variable we get from
    # main_app/config/puma.rb
    def connection
      # currently assume default URL
      Messaging::BunnyConnection.new(nil).connection
    end

    # Config variable for queue names that can be filled in
    # main_app/config/initializers/messaging.rb
    mattr_accessor :video_capture_exchange
    # this function maps the vars from main app into this engine
    def setup(&block)
      yield self
    end

    # Memoize connection client objects
    mattr_accessor :video_capture_client
  end
end
