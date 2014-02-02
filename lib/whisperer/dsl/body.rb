module Whisperer
  class Dsl
    class Body
      def initialize(container)
        @container = container
      end

      def encoding(val)
        @container.encoding = val
      end

      def string(val)
        @container.string = val
      end
    end # class Body
  end # class Dsl
end # module Whisperer