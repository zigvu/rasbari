require 'yaml'

module Messaging
  module Config
    class Reader
      attr_reader :config

      def initialize(yamlConfigFile)
        raise "Config file #{yamlConfigFile} doesn't exist" if !File.exist?(yamlConfigFile)

        if Module.const_defined?('Rails')
          env = Rails.env
        else
          env = 'development'
          env = ENV['RAILS_ENV'] if ENV['RAILS_ENV']
        end

        @config ||= begin
          all_config = YAML.load_file(yamlConfigFile) || {}
          env_config = all_config[env]

          config = Messaging::BaseLibs::DeepSymbolize.convert(env_config) if env_config
          config
        end
      end
    end
  end
end
