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
      Messaging.files_to_load.sort { |a, b| Messaging.dirnameComp(a, b) } .each { |file|
        require_relative file
      }
    end
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
