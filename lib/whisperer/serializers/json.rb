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
          fetch_attrs(@obj)
        end

        # This method returns give data as it is.
        # The purpose of this method is to give a way in child classes
        # to alter data structure before converting data.
        def post_prepare_data(data)
          data
        end

        def fetch_attrs(obj)
          if obj.respond_to?(:marshal_dump)
            obj.marshal_dump
          else
            obj.instance_variables.each_with_object({}) do |attr, memo|
              memo[attr[1..-1]] = @obj.instance_variable_get(attr)
              memo
            end
          end
        end
    end # class Json
  end # module Serializers
end # module Whisperer