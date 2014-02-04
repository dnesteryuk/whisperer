module Whisperer
  class Dsl
    class Base
      def self.link_dsl(name)
        define_method(name) do |&block|
          sub_dsl = Whisperer::Dsl.const_get(name.capitalize).new(
            @container.public_send(name)
          )

          sub_dsl.instance_eval &block
        end
      end

      def initialize(container)
        @container = container
      end
    end # class Base
  end # module Dsl
end # module Whisperer