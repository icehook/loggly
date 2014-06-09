module Loggly
  class Model
    include Logging

    attr_accessor :attributes

    def initialize(attributes = {})
      @attributes = OpenStruct.new(attributes)
    end

    def to_hash
      @attributes.marshal_dump
    end

    def to_json(pretty = false)
      MultiJson.dump(self.to_hash, :pretty => pretty)
    end

    def to_log(options = {})
      self.to_json(true)
    end

    module ClassMethods

      def from_hash(h)
        new h
      end

      def from_json(s)
        from_hash MultiJson.load(s, :symbolize_keys => true)
      end

    end

    extend ClassMethods

  end
end
