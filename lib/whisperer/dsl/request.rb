require_relative '../request'
require_relative 'base'

module Whisperer
  class Dsl
    class Request < Base
      def self.build
        Request.new(
          Whisperer::Request.new
        )
      end

      def initialize(container)
        @container = container
      end

      def uri(val)
        @container.uri = val
      end

      def method(val)
        @container.method = val
      end
    end # class Request
  end # module Dsl
end # module Whisperer