require_relative 'record/request'
require_relative 'record/response'

module Whisperer
  class Record
    include Virtus.model

    attribute :request,      Whisperer::Request,  default: proc { Whisperer::Request.new }
    attribute :response,     Whisperer::Response, default: proc { Whisperer::Response.new }
    attribute :http_version, String, default: ''
    attribute :recorded_at,  String, default: proc { Time.now.httpdate }

    def merge!(model)
      merge_attrs(model, self)
    end

    protected
      # TODO: think about moving it to some another object
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
              def_val = (attr_info.default_value.call rescue attr_info.default_value)
              is_default = def_val == container[attr]
            end

            if container[attr].nil? || is_default
              container[attr] = val
            end
          end
        end
      end
  end # class Record
end # module Whisperer