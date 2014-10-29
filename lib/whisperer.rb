require 'whisperer/version'

require 'virtus'
require 'vcr'

require 'whisperer/config'

require 'whisperer/placeholder'
require 'whisperer/dsl'
require 'whisperer/helpers'

require 'whisperer/convertors/hash'
require 'whisperer/convertors/interaction'

require 'whisperer/serializers/json'
require 'whisperer/serializers/json_multiple'

require 'whisperer/preprocessors'
require 'whisperer/preprocessors/content_length'

module Whisperer
  @fixture_records = ThreadSafe::Hash.new
  @serializers     = ThreadSafe::Hash.new

  class << self
    attr_reader :fixture_records
    attr_reader :serializers

    def define(name, options = {}, &block)
      dsl = Dsl.build
      dsl.instance_eval &block
      record = dsl.container

      if options[:parent]
        original_record = fixture_records[options[:parent]]

        if original_record.nil?
          raise ArgumentError.new("Parent record \"#{options[:parent]}\" is not declired.")
        else
          record.merge!(original_record)
        end
      end

      fixture_records[name.to_sym] = record
    end

    # Returns true if at least one factory is defined, otherwise returns false.
    def defined_any?
      fixture_records.size > 0
    end

    def generate(name)
      name = name.to_sym

      unless fixture_records[name]
        raise NoFixtureRecordError.new("There is not fixture builder with \"#{name}\" name.")
      end

      container = fixture_records[name]

      Preprocessors.process!(container)

      interaction = Convertors::Interaction.convert(container)

      path_to_fixture = "#{VCR.configuration.cassette_library_dir}/#{container.sub_path}/#{name}.yml"

      if File.exists?(path_to_fixture)
        File.unlink(
          path_to_fixture
        )
      end

      cassette = VCR::Cassette.new("#{container.sub_path}/#{name}")
      cassette.record_http_interaction(
        interaction
      )

      cassette.eject

      File.read(path_to_fixture)
    end

    def generate_all
      if defined_any?
        fixture_records.each do |name, container|
          generate(name)
        end
      else
        raise NoFixtureRecordError.new('Fixture builders are not found.')
      end
    end

    def serializer(name)
      unless serializers[name]
        raise ArgumentError.new("There is not serializer registered with \"#{name}\" name")
      end

      serializers[name]
    end

    def register_serializer(name, class_name)
      serializers[name] = class_name
    end
  end

  class NoFixtureRecordError < ArgumentError; end
end


Whisperer.register_serializer(:json, Whisperer::Serializers::Json)
Whisperer.register_serializer(:json_multiple, Whisperer::Serializers::JsonMultiple)

Whisperer::Preprocessors.register(:content_length, Whisperer::Preprocessors::ContentLength)