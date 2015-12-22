# Note: This relies in monkeypatching of module in
# config/initializers/monkeypatch.rb

module BaseNonPersisted
  def self.zextended(base, arr, options)
    # include general class and instance methods
    base.extend ClassMethods
    base.send :include, InstanceMethods
    # get prefix from options
    prefix = options[:prefix]
    prefixName = prefix.capitalize
    # change array elements into methods
    arr.each do |ss|
      methodName = ss.slice(0,1).capitalize + ss.slice(1..-1)
      # query method: Example: isTypeState?
      base.send(:define_method, "is#{prefixName}#{methodName}?") do
        self.send(ss) == self.send(prefix)
      end
      # strings
      base.send(:define_method, "#{ss}") do
        return ss.to_s
      end
    end
    # get string repr
    base.send(:define_method, "to_s") do
      self.send(prefix)
    end
    # formatted hash for form input
    base.send(:define_method, "to_h") do
      arr.map{ |a| [a.split(/(?=[A-Z])/).map{ |w| w.capitalize }.join(" "), a] }
    end
  end

  module ClassMethods
    # relevant class methods
  end
  module InstanceMethods
    # activated instance methods
  end

end
