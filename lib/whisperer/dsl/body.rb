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

      def raw_data(data_obj, options = {})
        @container.data_obj        = data_obj
        @container.serializer_opts = options
      end

      def serializer(name)
        @container.serializer = name.to_sym
      end
    end # class Body
  end # class Dsl
end # module Whisperer