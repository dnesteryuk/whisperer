require_relative 'request'
require_relative 'response'

module Whisperer
  class Record
    include Virtus.model

    attribute :request,      Whisperer::Request,  default: proc { Whisperer::Request.new }
    attribute :response,     Whisperer::Response, default: proc { Whisperer::Response.new }
    attribute :http_version, String, default: ''

    def merge!(model)
      merge_attrs(model.attributes, self)
    end

    protected
      def merge_attrs(attrs, container)
        attrs.each do |attr, val|
          if val.respond_to?(:attributes)
            merge_attrs(val.attributes, container[attr])
          else
            if container[attr].nil?
              container[attr] = val
            end
          end
        end
      end
  end # class Record
end # module Whisperer