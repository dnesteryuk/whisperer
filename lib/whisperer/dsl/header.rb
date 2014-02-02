module Whisperer
  class Dsl
    class Header
      def initialize(container)
        @container = container
      end

      def respond_to?(meth_id)
        @container.respond_to?(meth_id)
      end

      protected
        def method_missing(meth_id, *args)
          unless @container.respond_to?(meth_id)
            @container.attribute(meth_id, String)
          end

          @container.public_send("#{meth_id}=", *args)
        end
    end # class Header
  end # class Dsl
end # module Whisperer