require 'multi_json'
require_relative 'base'

module Whisperer
  module Serializers
    class Json < Base
      def serialize
        data = @obj.marshal_dump

        MultiJson.dump(data)
      end
    end # class Json
  end # module Serializers
end # module Whisperer