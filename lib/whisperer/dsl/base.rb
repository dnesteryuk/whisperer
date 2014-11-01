module Whisperer
  class BaseDsl
    class << self
      attr_reader :container_class

      def link_dsl(name)
        define_method(name) do |&block|
          class_name = Whisperer::Dsl.const_get(name.capitalize)

          sub_dsl = class_name.new(
            @container.public_send(name)
          )

          sub_dsl.instance_eval &block
        end
      end

      def link_container_class(val)
        @container_class = val
      end

      def build
        if self.container_class
          new(
            self.container_class.new
          )
        else
          raise ArgumentError.new(
            'You should associate a container (model) with this dsl class, before building it'
          )
        end
      end

      def add_writer(name)
        define_method(name) do |val|
          @container.public_send("#{name}=", val)
        end
      end
    end

    attr_reader :container

    def initialize(container)
      @container = container
    end
  end # class BaseDsl
end # module Whisperer