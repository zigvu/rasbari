module SampleEngine
  class Engine < ::Rails::Engine
    isolate_namespace SampleEngine

    # Append routes before initialization
    initializer "sample_engine", before: :load_config_initializers do |app|
      Rails.application.routes.append do
        mount SampleEngine::Engine, at: "/sample_engine"
      end
    end

    # Load files after initialization
    initializer "sample_engine", after: :load_config_initializers do |app|
      SampleEngine.files_to_load.each { |file|
        require_relative File.join("../..", file)
      }
    end

    # Change default generator to generate less files
    config.generators do |g|
      g.orm             :active_record
      g.template_engine :erb
      g.test_framework  :test_unit, fixture: false
      g.helper          false
      g.assets          false
      g.view_specs      false
      g.jbuilder        false
    end
  end
end
