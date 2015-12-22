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
  end
end
