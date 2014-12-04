module Whisperer
  class Merger
    extend Helpers

    add_builder 'merge'

    def initialize(child, parent)
      @child, @parent = child, parent
    end

    def merge
      merge_attrs(@parent, @child)
    end

    protected
      def merge_attrs(source, holder)
        source.attributes.each do |attr, val|
          if val.respond_to?(:attributes)
            merge_attrs(val, holder[attr])
          else
            # We need to make sure that such attribute is declared
            # for a record, otherwise, it cannot be written.
            if holder.class.attribute_set[attr].nil?
              holder.attribute(attr, source.class.attribute_set[attr])
            end

            attr_info = holder.class.attribute_set[attr]

            if holder[attr].nil? || holder[attr].respond_to?(:is_default)
              holder[attr] = val
            end
          end
        end
      end
  end
end