require_relative '../request'
require_relative 'base'
require_relative 'header'
require_relative 'body'

module Whisperer
  class Dsl
    class Request < Base
      def self.build
        Request.new(
          Whisperer::Request.new
        )
      end

      link_dsl 'header'
      link_dsl 'body'

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