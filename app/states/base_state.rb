# Note: This relies in monkeypatching of module in
# config/initializers/monkeypatch.rb

module BaseState
  def self.zextended(base, arr, options = {})
    # include general class and instance methods
    base.extend ClassMethods
    base.send :include, InstanceMethods
    # change array elements into methods
    arr.each do |ss|
      methodName = ss.slice(0,1).capitalize + ss.slice(1..-1)
      # query method: Example: isDownloadQueue?
      base.send(:define_method, "is#{methodName}?") do
        ss.to_s == getX()
      end
      # setter method: Example setDownloadQueue
      base.send(:define_method, "set#{methodName}") do
        setX(ss)
      end
      # progression
      base.send(:define_method, "isAfter#{methodName}?") do
        arr.index(getX()) > arr.index(ss)
      end
      base.send(:define_method, "isAtOrAfter#{methodName}?") do
        arr.index(getX()) >= arr.index(ss)
      end
      base.send(:define_method, "isBefore#{methodName}?") do
        arr.index(getX()) < arr.index(ss)
      end
      base.send(:define_method, "isAtOrBefore#{methodName}?") do
        arr.index(getX()) <= arr.index(ss)
      end
    end
    # get current
    base.send(:define_method, "get") do
      getX()
    end
    # make array accessible to instance methods
    base.send(:define_method, "attributeArr") do
      arr
    end
    # create class methods
    base.eigenclass.instance_eval do
      # individual element as method
      arr.each do |ss|
        define_method("#{ss}") do
          ss.to_s
        end
      end
      # formatted hash for form input
      define_method("to_h") do
        arr.map{ |a| [a.split(/(?=[A-Z])/).map{ |w| w.capitalize }.join(" "), a] }
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
