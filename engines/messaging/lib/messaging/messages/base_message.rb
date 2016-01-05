# Note: This relies in monkeypatching of module in
# config/initializers/monkeypatch.rb

module BaseMessage
  def self.zextended(base, arr, options = nil)
    # include general class and instance methods
    base.extend ClassMethods
    base.send :include, InstanceMethods

    # change array elements into methods
    arr.each do |ss|
      # base.send(:attr_accessor, ss)
      base.send(:attr_reader, ss)
      base.send(:define_method, "#{ss}=") do |arg|
        self.instance_variable_set("@#{ss}", arg.to_s)
      end
    end
    base.send(:define_method, "attributes") do
      arr
    end
  end

  module ClassMethods
    # relevant class methods
  end
  module InstanceMethods
    # activated instance methods
  end

  class Common
    def initialize(category, name, message)
      attributes.each do |a|
        instance_variable_set("@#{a}", nil)
      end
      @category = category
      @name = name

      if message != nil
        message.each do |k, v|
          if(instance_variable_defined?("@#{k}"))
            instance_variable_set("@#{k}", v)
          # else
          #   Messaging.logger.warn("Instance variable @#{k} not set")
          end
        end
      end
    end

    def isSameType?(anoMes)
      anoMes.category == @category && anoMes.name == @name
    end

    def to_hash
      retJson = {}
      attributes.each do |a|
        retJson[a] = "#{self.send(a)}"
      end
      retJson
    end
    def to_json
      to_hash.to_json
    end
    def to_s
      to_json.to_s
    end

  end

end
