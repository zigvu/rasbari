require "logger"
require "messaging/version"

# load files based on whether it is loaded as Rails engine or not
if Module.const_defined?('Rails')
  require "messaging/engine"
else
  require "non_rails/monkeypatch"
end

module Messaging
  def self.files_to_load
    lib = File::expand_path('..', __FILE__)
    templateFolders = ["#{lib}/messaging", "#{lib}/non_rails"]
    nonTemplateFolders = Dir["#{lib}/*"] - templateFolders
    nonTemplateFiles = []
    nonTemplateFolders.each do |ntf|
      # assume that all files are namespaced
      Dir["#{ntf}/*.rb"].each do |f|
        nonTemplateFiles << File.join(File.dirname(f), File.basename(f, ".*"))
      end
    end

    nonTemplateFiles
  end

  mattr_accessor :_logger
  def self.logger
    Messaging._logger ||= begin
      if Module.const_defined?('Rails')
        Rails.logger
      else
        logger = Logger.new(STDOUT)
        logger.level = Logger::DEBUG
        logger.datetime_format = "%Y-%m-%d %H:%M:%S"
        logger
      end
    end
  end

  # Memoize config
  mattr_accessor :_config
  def self.config
    Messaging._config ||= begin
      yamlConfigFile = File::expand_path('../config/rabbit.yml', __FILE__)
      Messaging._config = Config::Reader.new(yamlConfigFile).config
    end
  end


  # Memoize connection objects
  mattr_accessor :_cache
  def self.cache
    Messaging._cache ||= begin
      Messaging._cache = Connections::Cache.new
    end
  end

  # If using in rails context: DO NOT call this directly
  # instead use the global thread safe
  # $bunny_connection variable we get from
  # main_app/config/puma.rb
  def self.connection
    # currently assume default URL
    Connections::BunnyConnection.new(nil).connection
  end
end

# load files if not used as engine
if !Module.const_defined?('Rails')
  Messaging.files_to_load.each { |file|
    require_relative file
  }
end
