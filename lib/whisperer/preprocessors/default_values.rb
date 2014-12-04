require_relative 'base'

module Whisperer
  module Preprocessors
    class DefaultValues < Base
      def process
        fill_default_vals(@record)
      end

      private
        def fill_default_vals(holder)
          holder.attributes.each do |attr, val|
            if val.respond_to?(:attributes)
              fill_default_vals(val)
            else
              holder[attr] = val.to_default if val.respond_to?(:is_default)
            end
          end
        end
    end # class DefaultValues
  end # module Preprocessors
end # module Whisperer