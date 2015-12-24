# # needed for load order
require_relative "header_types"
require_relative "header_states"

module Messaging
  module Messages
    class Header
      attr_accessor :type, :state

      def initialize(jsonHeader)
        @type = Messaging::Messages::HeaderTypes.new(jsonHeader['type'])
        @state = Messaging::Messages::HeaderStates.new(jsonHeader['state'])
      end
      def to_json
        { type: @type.to_s, state: @state.to_s }
      end
      def to_s
        to_json.to_s
      end

      # define class methods
      eigenclass.instance_eval do
        Messaging::Messages::HeaderTypes.types.each do |t|
          Messaging::Messages::HeaderStates.states.each do |s|
            # self.pingSuccess
      			define_method("#{t}#{s.capitalize}") do
              return Messaging::Messages::Header.new({ 'type' => t, 'state' => s })
      			end
          end
        end
      end

      # defin instance methods
      Messaging::Messages::HeaderTypes.types.each do |t|
        Messaging::Messages::HeaderStates.states.each do |s|
          # self.isPingSuccess?
          define_method("is#{t.capitalize}#{s.capitalize}?") do
            return ("#{@type}" == "#{t}") && ("#{@state}" == "#{s}")
          end
        end
      end

    end
  end
end
