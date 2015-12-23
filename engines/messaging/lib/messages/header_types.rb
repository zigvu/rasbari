# Note: This relies in monkeypatching of module in
# config/initializers/monkeypatch.rb (for Rails)
# messaging/monkeypatch.rb (for non-Rails)

module Messages
  class HeaderTypes
    def self.types
      ["ping", "status", "data"]
    end
    zextend BaseNonPersisted, Messages::HeaderTypes.types, { prefix: 'type' }

    attr_reader :type

    def initialize(t)
      @type = t
    end
  end
end
