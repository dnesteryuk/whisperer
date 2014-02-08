module Whisperer
  module Serializers
    class Hash
      def initialize(obj)
        @obj = obj
      end

      # Converts the current with all related objects to hash
      def serialize
        to_hash(@obj)
      end

      private
        def to_hash(val)
          attrs = val.to_hash

          attrs.each do |attr, val|
            if val.respond_to?(:to_hash)
              attrs[attr] = to_hash(val)
            end
          end

          attrs
        end
    end # class Hash
  end # module Serializers
end # module Whisperer