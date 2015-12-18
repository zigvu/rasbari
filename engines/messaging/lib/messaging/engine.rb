module Messaging
  class Engine < ::Rails::Engine
    isolate_namespace Messaging

    # Append routes before initialization
    initializer "messaging", before: :load_config_initializers do |app|
      Rails.application.routes.append do
        mount Messaging::Engine, at: "/messaging"
      end
    end

    # Load files after initialization
    initializer "messaging", after: :load_config_initializers do |app|
      Messaging.files_to_load.each { |file|
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
