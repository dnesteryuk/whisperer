require 'multi_json'
require_relative 'base'

module Whisperer
  module Serializers
    class Json < Base
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