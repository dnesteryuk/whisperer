require_relative '../request'

require_relative 'header'
require_relative 'body'

module Whisperer
  class Dsl
    class Request
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

      def header(&block)
        header = Whisperer::Dsl::Header.new(
          @container.header
        )

        header.instance_eval &block
      end

      def body
      end

      def method(val)
        @container.method = val
      end
    end # class Request
  end # module Dsl
end # module Whisperer