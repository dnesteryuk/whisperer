require_relative '../response'
require_relative 'base'
require_relative 'status'

module Whisperer
  class Dsl
    class Response < Base
      def status(&block)
        status = Whisperer::Dsl::Status.new(
          @container.status
        )

        status.instance_eval &block
      end
    end # class Response
  end # module Dsl
end # module Whisperer