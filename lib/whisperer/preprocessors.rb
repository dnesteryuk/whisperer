module Whisperer
  module Preprocessors
    @preprocessors = ThreadSafe::Hash.new

    class << self
      attr_reader :preprocessors

      def register(name, class_name)
        preprocessors[name] = class_name
      end

      def process!(container)
        preprocessors.each do |name, class_names|
          class_names.process(container)
        end
      end
    end
  end
end