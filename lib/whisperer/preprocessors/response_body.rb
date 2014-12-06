require_relative 'base'

module Whisperer
  module Preprocessors
    class ResponseBody < Base
      def process
        body = @record.response.body

        unless body.data_obj.nil?
          body.string = serializer_class(body.serializer.to_sym).serialize(
            body.data_obj,
            body.serializer_opts
          )
        end
      end

      protected
        def serializer_class(name)
          Whisperer::Serializers.fetch(name)
        end
    end
  end
end