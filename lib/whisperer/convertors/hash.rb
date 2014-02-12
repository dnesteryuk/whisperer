require 'active_support/core_ext/string/inflections'

module Whisperer
  module Convertors
    class Hash
      def initialize(obj)
        @obj = obj
      end

      # Converts the current with all related objects to hash
      def convert
        to_hash(@obj)
      end

      private
        def to_hash(val)
          new_attrs, attrs = {}, val.to_hash

          attrs.each do |attr, val|
            new_attrs[prepare_key(attr)] = if val.respond_to?(:to_hash)
              to_hash(val)
            else
              val
            end
          end

          new_attrs
        end

        def prepare_key(key)
          key.to_s
        end
    end # class Hash
  end # module Convertors
end # module Whisperer