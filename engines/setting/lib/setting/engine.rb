module Setting
  class Engine < ::Rails::Engine
    isolate_namespace Setting

    # Append routes before initialization
    initializer "setting", before: :load_config_initializers do |app|
      Rails.application.routes.append do
        mount Setting::Engine, at: "/setting"
      end
    end

    # Load files after initialization
    initializer "setting", after: :load_config_initializers do |app|
      Setting.files_to_load.each { |file|
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
