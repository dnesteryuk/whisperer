require 'multi_json'

require_relative 'base'

module Whisperer
  module Serializers
    class Base
      extend Helpers

      add_builder :serialize

      attr_reader :options

      def initialize(obj, options: {})
        @obj     = obj
        @options = options
      end

      def serialize
        raise NotImplementedError
      end
    end # class Base
  end # module Serializers
end # module Whisperer