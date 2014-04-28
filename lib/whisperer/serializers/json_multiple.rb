require 'multi_json'
require_relative 'base'

module Whisperer
  module Serializers
    class JsonMultiple < Base
      def serialize
        data = @obj.map do |item|
          item.marshal_dump
        end

        MultiJson.dump(data)
      end
    end # class JsonMultiple
  end # module Serializers
end # module Whisperer