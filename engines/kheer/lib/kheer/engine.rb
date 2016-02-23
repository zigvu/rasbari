module Kheer
  class Engine < ::Rails::Engine
    isolate_namespace Kheer

    # Append routes before initialization
    initializer "kheer", before: :load_config_initializers do |app|
      Rails.application.routes.append do
        mount Kheer::Engine, at: "/kheer"
      end
    end

    # Load files after initialization
    initializer "kheer", after: :load_config_initializers do |app|
      Kheer.files_to_load.each { |file|
        require_relative file
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
      g.templates.unshift File::expand_path('../../templates', __FILE__)
    end
  end
end
