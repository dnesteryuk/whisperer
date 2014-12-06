module Whisperer
  module Serializers
    @serializers = ThreadSafe::Hash.new

    class << self
      attr_reader :serializers

      def fetch(name)
        unless serializers[name]
          raise ArgumentError.new("There is not serializer registered with \"#{name}\" name")
        end

        serializers[name]
      end

      def register(name, class_name)
        serializers[name] = class_name
      end
    end
  end
end