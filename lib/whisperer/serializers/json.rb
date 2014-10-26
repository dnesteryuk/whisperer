require 'multi_json'
require_relative 'base'

module Whisperer
  module Serializers
    class Json < Base
      def initialize(obj, options: {}, json_dumper: MultiJson)
        super obj, options: options

        @json_dumper = json_dumper
      end

      def serialize
        data = prepare_data
        data = post_prepare_data(data)

        @json_dumper.dump(data)
      end

      protected
        def prepare_data
          @obj.marshal_dump
        end

        # This method returns give data as it is.
        # The purpose of this method is to give a way in child classes
        # to alter data structure before converting data.
        def post_prepare_data(data)
          data
        end
    end # class Json
  end # module Serializers
end # module Whisperer