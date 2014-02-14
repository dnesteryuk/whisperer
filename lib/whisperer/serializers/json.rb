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
        data = if @obj.kind_of?(Array)
          @obj.map do |item|
            item.marshal_dump
          end
        else
          @obj.marshal_dump
        end

        MultiJson.dump(data)
      end
    end # class Json
  end # module Serializers
end # module Whisperer