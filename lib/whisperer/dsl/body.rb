require_relative 'base'

module Whisperer
  class Dsl
    class Body < BaseDsl
      add_writer 'encoding'

      def factory(name, serializer = :json)
        #FactoryGirl.build(name)
      end
    end # class Body
  end # class Dsl
end # module Whisperer