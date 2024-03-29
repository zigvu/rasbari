require "logger"
require "messaging/version"
# extra files needed for load order
require "messaging/messages/base_non_persisted"
require "messaging/messages/base_message"

# load files based on whether it is loaded as Rails engine or not
if Module.const_defined?('Rails')
  require "messaging/engine"
else
  require "messaging/non_rails/monkeypatch"
end

module Messaging
  def self.files_to_load
    lib = File::expand_path('..', __FILE__)
    templateFolders = ["#{lib}/messaging/non_rails"]
    nonTemplateFolders = Dir["#{lib}/messaging/*"] - templateFolders
    nonTemplateFiles = []
    nonTemplateFolders.each do |ntf|
      # assume that all files are namespaced
      Dir["#{ntf}/**/*.rb"].each do |f|
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
        Messaging::BaseLibs::Mlogger.new
      end
    end
  end

  # Memoize config
  mattr_accessor :_config
  def self.config
    Messaging._config ||= begin
      yamlConfigFile = File::expand_path('../messaging/config/rabbit.yml', __FILE__)
      Messaging._config = Messaging::Config::Reader.new(yamlConfigFile).config
    end
  end

  # Memoize connection objects
  mattr_accessor :_rasbari_cache
  def self.rasbari_cache
    Messaging._rasbari_cache ||= begin
      raise "Cannot initilize rasbari cache in non rails environment" if !Module.const_defined?('Rails')
      Messaging._rasbari_cache = Messaging::Connections::RasbariCache.new
    end
  end

  # If using in rails context: DO NOT call this directly
  # instead use the global thread safe
  # $bunny_connection variable we get from
  # main_app/config/puma.rb
  def self.connection
    # currently assume default URL
    Messaging::Connections::BunnyConnection.new(nil).connection
  end

  # Compare directory first by depth
  # then if required, by dictionary order
  def self.dirnameComp(stra, strb)
    a_count = countSlash( stra)
    b_count = countSlash( strb)
    ret = a_count <=> b_count
    if ret == 0 
      ret = stra <=> strb
    end
    ret
  end

  def self.countSlash(str) 
    ret = 0
    slashPos = 0;
    if ! str.nil?
      begin
        slashPos = str.index('/', slashPos)
        if !slashPos.nil?
          ret += 1
          slashPos += 1
        end
      end while !slashPos.nil?

    end
    ret
  end

end

# load files if not used as engine
if !Module.const_defined?('Rails')
  Messaging.files_to_load.sort {|a,b| Messaging.dirnameComp(a,b)} . each { |file|
    require_relative file
  }
end
