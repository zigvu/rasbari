# Author: Evan

# Here be dragons! Tread carefully

# This should only be loaded when in non-rails context.
# For rails context, we use different monkeypatch file:
# config/initializers/monkeypatch.rb
if Module.const_defined?('Rails')
  raise "Messaging monkeypatch cannot be loaded in non Rails context!"
end

# Copy rails array option extractor
class Array
  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end
end

class Module
  # Monkeypatch module to allow `extend` with more capability
  def zextend(mod, *args)
    returnMod = include(mod)
    mod.zextended(self, *args) if mod.respond_to?(:zextended)
    returnMod
  end

  # Copy rails mattr
  # https://github.com/rails/rails/blob/2-1-stable/activesupport/lib/active_support/core_ext/module/attribute_accessors.rb
  def mattr_reader(*syms)
    syms.each do |sym|
      next if sym.is_a?(Hash)
      class_eval(<<-EOS, __FILE__, __LINE__)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end

        def self.#{sym}
          @@#{sym}
        end
        def #{sym}
          @@#{sym}
        end
      EOS
    end
  end

  def mattr_writer(*syms)
    options = syms.extract_options!
    syms.each do |sym|
      class_eval(<<-EOS, __FILE__, __LINE__)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end

        def self.#{sym}=(obj)
          @@#{sym} = obj
        end

        #{"
        def #{sym}=(obj)
          @@#{sym} = obj
        end
        " unless options[:instance_writer] == false }
      EOS
    end
  end

  def mattr_accessor(*syms)
    mattr_reader(*syms)
    mattr_writer(*syms)
  end
end
