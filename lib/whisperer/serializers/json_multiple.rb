require 'multi_json'
require_relative 'json'

module Whisperer
  module Serializers
    class JsonMultiple < Json
      protected
        def prepare_data
          @obj.map do |item|
            item.marshal_dump
          end
        end
    end # class JsonMultiple
  end # module Serializers
end # module Whisperer