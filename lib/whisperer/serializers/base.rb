require 'multi_json'

require_relative 'base'

module Whisperer
  module Serializers
    class Base
      extend Helpers

      add_builder :serialize

      def initialize(obj, options: {})
        @obj = obj
      end

      def serialize
        raise NotImplementedError
      end
    end # class Base
  end # module Serializers
end # module Whisperer