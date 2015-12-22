module Messaging
  # Copy rails OrderedOptions
  # https://github.com/rails/rails/blob/4-2-stable/activesupport/lib/active_support/ordered_options.rb
  class OrderedOptions < Hash
    alias_method :_get, :[] # preserve the original #[] method
    protected :_get # make it protected

    def []=(key, value)
      super(key.to_sym, value)
    end

    def [](key)
      super(key.to_sym)
    end

    def method_missing(name, *args)
      name_string = name.to_s
      if name_string.chomp!('=')
        self[name_string] = args.first
      else
        self[name]
      end
    end

    def respond_to_missing?(name, include_private)
      true
    end
  end
end
