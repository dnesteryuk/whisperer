module Whisperer
  class Generator
    extend Helpers

    add_builder 'generate'

    attr_reader :record

    def initialize(record, name)
      @record, @name = record, name
    end

    def generate
      Preprocessors.process!(record)

      interaction = Convertors::Interaction.convert(record)

      self.uniq_fixture!

      cassette = VCR::Cassette.new("#{record.sub_path}/#{@name}")
      cassette.record_http_interaction(
        interaction
      )

      cassette.eject

      File.read(path_to_fixture)
    end

    protected
      def path_to_fixture
        "#{VCR.configuration.cassette_library_dir}/#{record.sub_path}/#{@name}.yml"
      end

      def uniq_fixture!
        if File.exists?(path_to_fixture)
          File.unlink(
            path_to_fixture
          )
        end
      end
  end
end