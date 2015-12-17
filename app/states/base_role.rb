# Note: This relies in monkeypatching of module in
# config/initializers/monkeypatch.rb

module BaseRole
  def self.zextended(base, arr, options = {})
    # include general class and instance methods
    base.extend ClassMethods
    base.send :include, InstanceMethods
    # change array elements into methods
    arr.each do |ss|
      methodName = ss.slice(0,1).capitalize + ss.slice(1..-1)
      # query method: Example: isDownloadQueue?
      base.send(:define_method, "is#{methodName}?") do
        currentState = getX
        self.send(ss) == currentState
      end
      # setter method: Example setDownloadQueue
      base.send(:define_method, "set#{methodName}") do
        setX(ss)
      end
      # heirarchy
      base.send(:define_method, "isAtLeast#{methodName}?") do
        currentState = getX
        arr.index(currentState) >= arr.index(ss)
      end
      base.send(:define_method, "isBelow#{methodName}?") do
        currentState = getX
        arr.index(currentState) < arr.index(ss)
      end
      # strings
      base.send(:define_method, "#{ss}") do
        return ss.to_s
      end
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

  # this is inherited from implementing classes
  class ArAccessor
    def initialize(collArr, tableObject, columnName)
      @collArr = collArr
      @tableObject = tableObject
      @columnName = columnName
    end

    # methods for sub classes
    def getX
      @tableObject.send(@columnName)
    end
    def setX(setValue)
      @tableObject.update({@columnName => setValue})
    end
    # get humanized version
    def to_s
      getX().split(/(?=[A-Z])/).map{ |w| w.capitalize }.join(" ")
    end
    # see if is valid
    def valid?(r)
      @collArr.include?(r)
    end
  end
end
