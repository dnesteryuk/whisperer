# This class calculates a content length for a reponse body
# if it is not defined in a fixture record.
module Whisperer
  module Preprocessors
    class ContentLength
      extend Helpers

      add_builder :process

      def initialize(record)
        @record = record
      end

      def process
        if @record.response.headers.content_length.nil?
          @record.response.headers.content_length = @record.response.body.string.size
        end
      end
    end # class ContentLength
  end # module Preprocessors
end # module Whisperer