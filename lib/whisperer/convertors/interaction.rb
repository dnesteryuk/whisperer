module Whisperer
  module Convertors

    # Converts
    class Interaction
      extend Helpers

      add_builder :convert

      def initialize(container)
        @container = container
      end

      def convert
        hash = Whisperer::Convertors::Hash.convert(@container)

        VCR::HTTPInteraction.from_hash(hash)
      end
    end
  end
end