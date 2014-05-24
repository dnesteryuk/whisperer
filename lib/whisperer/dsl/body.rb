require_relative 'base'

module Whisperer
  class Dsl
    class Body < BaseDsl
      add_writer 'encoding'
      add_writer 'string'

      def factory(name, *args)
        model = FactoryGirl.build(name)

        raw_data(model, *args)
      end

      def factories(names, *args)
        models = names.map do |name|
          FactoryGirl.build(name)
        end

        raw_data(models, *args)
      end

      def raw_data(data, serializer = :json, options = {})
        @container.string = serializer_class(serializer).serialize(
          data,
          options
        )
      end

      protected
        def serializer_class(name)
          Whisperer.serializer(name)
        end
    end # class Body
  end # class Dsl
end # module Whisperer