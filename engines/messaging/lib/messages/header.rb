# needed for load order
require_relative "header_types"
require_relative "header_states"

module Messages
  class Header
    attr_accessor :type, :state

    def initialize(jsonHeader)
      @type = Messages::HeaderTypes.new(jsonHeader['type'])
      @state = Messages::HeaderStates.new(jsonHeader['state'])
    end
    def to_json
      { type: @type.to_s, state: @state.to_s }
    end
    def to_s
      to_json.to_s
    end

    # define class methods
    eigenclass.instance_eval do
      Messages::HeaderTypes.types.each do |t|
        Messages::HeaderStates.states.each do |s|
          # self.pingSuccess
    			define_method("#{t}#{s.capitalize}") do
            return Messages::Header.new({ 'type' => t, 'state' => s })
    			end
        end
      end
    end

    # defin instance methods
    Messages::HeaderTypes.types.each do |t|
      Messages::HeaderStates.states.each do |s|
        # self.isPingSuccess?
        define_method("is#{t.capitalize}#{s.capitalize}?") do
          return ("#{@type}" == "#{t}") && ("#{@state}" == "#{s}")
        end
      end
    end


  end
end
