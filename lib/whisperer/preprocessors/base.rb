module Whisperer
  module Preprocessors
    class Base
      extend Helpers

      add_builder :process

      def initialize(record)
        @record = record
      end
    end
  end
end