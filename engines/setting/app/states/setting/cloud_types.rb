module Setting
  class CloudTypes < BaseAr::ArAccessor

    def self.types
      ["local", "softLayer", "amazon", "microsoft"]
    end
    zextend BaseType, Setting::CloudTypes.types

    def initialize(machine)
      super(machine, :zcloud)
    end

  end
end
