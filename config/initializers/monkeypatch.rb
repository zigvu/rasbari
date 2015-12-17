# Author: Evan

# Here be dragons! Tread carefully

# Monkeypatch module to allow `extend` with more capability
class Module
  def zextend(mod, *args)
    returnMod = include(mod)
    mod.zextended(self, *args) if mod.respond_to?(:zextended)
    returnMod
  end
end
