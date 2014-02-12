require 'multi_json'

module Whisperer
  module Serializers
    class Json
      def self.serialize(obj)
        serializer = new(obj)
        serializer.serialize
      end

      def initialize(obj)
        @obj = obj
      end

      def serialize
        MultiJson.dump(@obj.marshal_dump)
      end
    end # class Json
  end # module Serializers
end # module Whisperer