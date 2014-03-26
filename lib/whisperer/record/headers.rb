module Whisperer
  class Headers
    include Virtus.model

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