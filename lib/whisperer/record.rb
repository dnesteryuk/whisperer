require_relative 'request'
require_relative 'response'

require 'pry'

module Whisperer
  class Record
    include Virtus.model

    attribute :request,      Whisperer::Request,  default: proc { Whisperer::Request.new }
    attribute :response,     Whisperer::Response, default: proc { Whisperer::Response.new }
    attribute :http_version, String, default: ''

    def merge!(model)
      merge_attrs(model, self)
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

            if container[attr].nil?
              container[attr] = val
            end
          end
        end
      end
  end # class Record
end # module Whisperer