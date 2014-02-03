require_relative 'header'
require_relative 'body'

module Whisperer
  class Dsl
    class Base
      def initialize(container)
        @container = container
      end

      def header(&block)
        header = Whisperer::Dsl::Header.new(
          @container.header
        )

        header.instance_eval &block
      end

      def body(&block)
        body = Whisperer::Dsl::Body.new(
          @container.body
        )

        body.instance_eval &block
      end
    end # class Base
  end # module Dsl
end # module Whisperer