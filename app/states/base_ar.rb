# Note: This relies in monkeypatching of module in
# config/initializers/monkeypatch.rb

module BaseAr
  # this is inherited from implementing classes
  class ArAccessor
    def initialize(tableObject, columnName)
      # attributeArr is defined by module monkeypatch
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
    # get humanized version of current role
    def to_s
      getX().split(/(?=[A-Z])/).map{ |w| w.capitalize }.join(" ")
    end
    # see if it is valid
    def valid?(r)
      attributeArr.include?(r)
    end
  end
end
