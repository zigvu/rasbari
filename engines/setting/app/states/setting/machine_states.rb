module Setting
  class MachineStates < BaseAr::ArAccessor

    def self.states
      ["unknown", "provisioning", "ready", "contracted", "working"]
    end
    zextend BaseState, Setting::MachineStates.states

    def initialize(machine)
      super(machine, :zstate)
    end

  end
end
