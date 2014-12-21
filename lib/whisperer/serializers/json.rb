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
          # When an OpenStruct object is given
          if obj.respond_to?(:marshal_dump)
            obj.marshal_dump
          # When an object has the attributes method
          elsif obj.respond_to?(:attributes)
            obj.attributes
          # When a pure ruby object is given
          else
            obj.instance_variables.each_with_object({}) do |attr, memo|
              name = attr[1..-1]

              # If there is an accessor method to read a value,
              # we should use it.
              memo[name] = if obj.respond_to?(name)
                obj.public_send(name)
              else
                obj.instance_variable_get(attr)
              end

              memo
            end
          end
        end
    end # class Json
  end # module Serializers
end # module Whisperer