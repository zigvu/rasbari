module Setting
  class MachineTypes < BaseAr::ArAccessor

    def self.types
      ["local", "capture", "storage", "gpu"]
    end
    zextend BaseType, Setting::MachineTypes.types

    def initialize(machine)
      super(machine, :ztype)
    end

  end
end
