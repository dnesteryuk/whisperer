require_relative 'json'

module Whisperer
  module Serializers
    class JsonMultiple < Json
      protected
        def prepare_data
          @obj.map do |item|
            fetch_attrs(item)
          end
        end
    end # class JsonMultiple
  end # module Serializers
end # module Whisperer