require 'multi_json'
require_relative 'base'

module Whisperer
  module Serializers
    class Base
      def self.serialize(obj, options = {})
        serializer = new(obj)
        serializer.serialize
      end

      def initialize(obj)
        @obj = obj
      end

      def serialize
        raise NotImplementedError
      end
    end # class Base
  end # module Serializers
end # module Whisperer