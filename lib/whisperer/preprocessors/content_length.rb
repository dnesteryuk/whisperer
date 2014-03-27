module Whisperer
  module Preprocessors
    class ContentLength
      class << self
        def process(record)
          processor = new(record)
          processor.process
        end
      end

      def initialize(record)
        @record = record
      end

      def process
        if @record.response.headers.content_length.nil?
          @record.response.headers.content_length = @record.response.body.string.size
        end
      end
    end
  end
end