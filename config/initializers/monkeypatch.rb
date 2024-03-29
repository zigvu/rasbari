# Author: Evan

# Here be dragons! Tread carefully

class Object
  # Monkeypatch object to generate class methods
  def eigenclass
    class << self; self; end
  end
end

class Module
  # Monkeypatch module to allow `extend` with more capability
  def zextend(mod, *args)
    returnMod = include(mod)
    mod.zextended(self, *args) if mod.respond_to?(:zextended)
    returnMod
  end
end
