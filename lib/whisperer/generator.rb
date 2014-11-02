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

      self.uniq_cassette!

      cassette = VCR::Cassette.new("#{record.sub_path}/#{@name}")
      cassette.record_http_interaction(
        interaction
      )

      cassette.eject

      File.read(path_to_cassette)
    end

    protected
      def path_to_cassette
        "#{VCR.configuration.cassette_library_dir}/#{record.sub_path}/#{@name}.yml"
      end

      def uniq_cassette!
        if File.exists?(path_to_cassette)
          File.unlink(
            path_to_cassette
          )
        end
      end
  end
end