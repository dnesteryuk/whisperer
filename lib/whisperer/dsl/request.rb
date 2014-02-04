require_relative '../request'
require_relative 'base'
require_relative 'header'
require_relative 'body'

module Whisperer
  class Dsl
    class Request < BaseDsl
      link_container_class Whisperer::Request

      link_dsl 'header'
      link_dsl 'body'

      def uri(val)
        @container.uri = val
      end

      def method(val)
        @container.method = val
      end
    end # class Request
  end # module Dsl
end # module Whisperer