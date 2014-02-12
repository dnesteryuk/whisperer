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
          new_attrs, attrs = {}, val.to_hash

          attrs.each do |attr, val|
            new_attrs[attr.to_s] = if val.respond_to?(:to_hash)
              to_hash(val)
            else
              val
            end
          end

          new_attrs
        end
    end # class Hash
  end # module Serializers
end # module Whisperer