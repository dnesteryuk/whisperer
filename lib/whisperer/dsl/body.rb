require_relative 'base'

module Whisperer
  class Dsl
    class Body < BaseDsl
      add_writer 'encoding'

      def factory(name, serializer = :json)
        class_name = Whisperer::Serializers.const_get(serializer.to_s.capitalize)
        model = FactoryGirl.build(name)
        data  = class_name.serialize(model)

        @container.string = data
      end
    end # class Body
  end # class Dsl
end # module Whisperer