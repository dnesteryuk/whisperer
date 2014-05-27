require 'multi_json'
require_relative 'base'

module Whisperer
  module Serializers
    class Json < Base
      def initialize(obj, options: {}, json_dumper: MultiJson)
        super obj

        @json_dumper = json_dumper
      end

      def serialize
        data = prepare_data

        @json_dumper.dump(data)
      end

      protected
        def prepare_data
          @obj.marshal_dump
        end
    end # class Json
  end # module Serializers
end # module Whisperer