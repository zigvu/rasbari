module Kheer
  class ChiaModelStates < BaseAr::ArAccessor

    def self.states
      ["configuring", "finalized"]
    end
    zextend BaseState, Kheer::ChiaModelStates.states

    def initialize(chiaModel)
      super(chiaModel, :zstate)
    end

  end
end
