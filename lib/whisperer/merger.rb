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
      def merge_attrs(item, container)
        item.attributes.each do |attr, val|
          if val.respond_to?(:attributes)
            merge_attrs(val, container[attr])
          else
            # We need to make sure that such attribute is declared
            # for a record, otherwise, it cannot be written.
            if container.class.attribute_set[attr].nil?
              container.attribute(attr, item.class.attribute_set[attr])
            end

            attr_info = container.class.attribute_set[attr]

            is_default = false

            unless attr_info.nil?
              def_val = attr_info.default_value
              def_val = def_val.call if def_val.respond_to?(:call)

              is_default = def_val == container[attr]
            end

            if container[attr].nil? || is_default
              container[attr] = val
            end
          end
        end
      end
  end
end