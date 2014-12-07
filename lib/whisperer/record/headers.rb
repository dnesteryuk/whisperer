module Whisperer
  class Headers
     include Virtus.model

    def initialize(attrs = {})
      extend Virtus.model

      attrs.each do |attr, val|
        self.attribute(attr.to_sym, Object)
        self.public_send("#{attr}=", val)
      end

      super
    end

    def to_hash
      prepared_attrs, attrs = {}, super

      attrs.each do |key, val|
        key = key.to_s.titleize.split(' ').join('-')
        prepared_attrs[key] = val
      end

      prepared_attrs
    end
  end # class Header
end # module Whisperer