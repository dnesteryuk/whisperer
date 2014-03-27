require_relative 'base'

module Whisperer
  class Dsl
    class Body < BaseDsl
      add_writer 'encoding'

      def factory(name, serializer = :json)
        model = FactoryGirl.build(name)

        @container.string = serializer_class(serializer).serialize(model)
      end

      def factories(names, serializer = :json)
        models = names.map do |name|
          FactoryGirl.build(name)
        end

        @container.string = serializer_class(serializer).serialize(models)
      end

      protected
        def serializer_class(name)
          Whisperer.serializer(name)
        end
    end # class Body
  end # class Dsl
end # module Whisperer