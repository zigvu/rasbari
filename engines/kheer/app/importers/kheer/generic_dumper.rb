module Kheer
  class GenericDumper
    attr_accessor :items

    def initialize(mongoCollectionName)
      @mongoCollection = mongoCollectionName.constantize
      @items = []
      @mongoBatchInsertSize = 500
    end

    def canFlush?
      raise NotImplementedError("Subclasses need to implement canFlush?")
    end

    def add(item)
      @items << item
      return @items.count - 1 # return idx
    end

    def flush
      insertResult = nil
      if @items.count > 0
        insertResult = @mongoCollection.no_timeout.collection.insert_many(@items)
        @items = []
      end
      insertResult
    end

    def finalize
      insertResult = flush()
      @mongoCollection.no_timeout.create_indexes
      insertResult
    end

  end
end
