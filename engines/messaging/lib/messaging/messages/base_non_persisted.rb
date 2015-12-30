# Note: This relies in monkeypatching of module in
# config/initializers/monkeypatch.rb

module BaseNonPersisted
  def self.zextended(base, arr, options)
    # include general class and instance methods
    base.extend ClassMethods
    base.send :include, InstanceMethods
    # get prefix from options
    prefix = options[:prefix]
    # change array elements into methods
    arr.each do |ss|
      methodName = ss.slice(0,1).capitalize + ss.slice(1..-1)
      # query method: Example: isState?
      base.send(:define_method, "is#{methodName}?") do
        ss.to_s == self.send(prefix)
      end
    end
    # get string repr
    base.send(:define_method, "to_s") do
      self.send(prefix)
    end
    # equality
    base.send(:define_method, "==") do |another|
      self.send(prefix) == another.send(prefix)
    end
    # formatted hash for form input
    base.send(:define_method, "to_h") do
      arr.map{ |a| [a.split(/(?=[A-Z])/).map{ |w| w.capitalize }.join(" "), a] }
    end
    # create class methods
    base.eigenclass.instance_eval do
      arr.each do |ss|
        define_method("#{ss}") do
          return base.new(ss)
        end
      end
    end
  end

  module ClassMethods
    # relevant class methods
  end
  module InstanceMethods
    # activated instance methods
  end

end
