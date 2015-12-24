# Note: This relies in monkeypatching of module in
# config/initializers/monkeypatch.rb (for Rails)
# messaging/monkeypatch.rb (for non-Rails)

module VideoCapture
  class CaptureStates
    def self.states
      ["unknown", "ready", "capturing", "stopped"]
    end
    zextend BaseNonPersisted, VideoCapture::CaptureStates.states, { prefix: 'state' }

    attr_reader :state

    def initialize(s)
      @state = s
    end
  end
end
