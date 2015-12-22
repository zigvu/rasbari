require 'yaml'

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

        config = deepSymbolize(env_config, Messaging::OrderedOptions.new) if env_config
        config
      end
    end

    def deepSymbolize(h, newH)
      h.each do |k, v|
        if v.is_a?(Hash)
          newV = deepSymbolize(v, Messaging::OrderedOptions.new)
        else
          newV = v
        end
        newH.merge!({k => newV}.symbolize_keys)
      end
      newH
    end
  end
end
