module Messaging
  module BaseLibs
    # Convert nested hash into ordered_options
    class DeepSymbolize
      def self.convert(h)
        self.deepSymbolize(h, Messaging::BaseLibs::OrderedOptions.new)
      end

      def self.deepSymbolize(h, newH)
        h.each do |k, v|
          if v.is_a?(Hash)
            newV = self.deepSymbolize(v, Messaging::BaseLibs::OrderedOptions.new)
          else
            newV = v
          end
          newH.merge!({k => newV}.symbolize_keys)
        end
        newH
      end
    end
  end
end
