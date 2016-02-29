module Analysis
  class MiningStates < BaseAr::ArAccessor

    def self.states
      ["startSetup", "completeSetup", "working", "completeWorking", "deleted"]
    end
    zextend BaseState, Analysis::MiningStates.states

    def initialize(mining)
      super(mining, :zstate)
    end

  end
end
