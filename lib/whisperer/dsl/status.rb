module Whisperer
  class Dsl
    class Status
      def initialize(container)
        @container = container
      end

      def message(val)
        @container.message = val
      end

      def code(val)
        @container.code = val
      end
    end # class Status
  end # class Dsl
end # module Whisperer