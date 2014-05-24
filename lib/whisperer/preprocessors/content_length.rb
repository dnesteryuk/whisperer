require_relative 'base'

# This class calculates a content length for a response body
# if it is not defined in a fixture record.
module Whisperer
  module Preprocessors
    class ContentLength
      def process
        headers = @record.response.headers

        if hwaders.content_length.nil?
          headers.content_length = @record.response.body.string.size
        end
      end
    end # class ContentLength
  end # module Preprocessors
end # module Whisperer