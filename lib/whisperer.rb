require 'whisperer/version'

require 'virtus'
require 'vcr'

require 'whisperer/dsl'

require 'whisperer/convertors/hash'

require 'whisperer/serializers/json'
require 'whisperer/serializers/json_multiple'

require 'whisperer/preprocessors/content_length'

module Whisperer
  @fixture_records = ThreadSafe::Hash.new
  @serializers     = ThreadSafe::Hash.new
  @preprocessors   = ThreadSafe::Hash.new

  class << self
    attr_reader :fixture_records
    attr_reader :serializers
    attr_reader :preprocessors

    def define(name, options = {}, &block)
      dsl = Dsl.build
      dsl.instance_eval &block
      record = dsl.container

      if options[:parent]
        original_record = fixture_records[options[:parent]]

        if original_record.nil?
          raise ArgumentError.new("Parent record with \"#{options[:parent]}\" is not declired.")
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

      preprocessors.each do |name, class_names|
        class_names.process(container)
      end

      hash = Whisperer::Convertors::Hash.convert(container)

      interaction = VCR::HTTPInteraction.from_hash(
        hash
      )

      cassette = VCR::Cassette.new(name)
      cassette.record_http_interaction(
        interaction
      )

      cassette.eject

      File.read(
        "#{VCR.configuration.cassette_library_dir}/#{name}.yml"
      )
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

    def register_preprocessor(name, class_name)
      preprocessors[name] = class_name
    end

    def register_serializer(name, class_name)
      serializers[name] = class_name
    end

    def serializer(name)
      unless serializers[name]
        raise ArgumentError.new("There is not serializer registered with \"#{name}\" name")
      end

      serializers[name]
    end
  end

  class NoFixtureRecordError < ArgumentError; end
end


Whisperer.register_serializer(:json, Whisperer::Serializers::Json)
Whisperer.register_serializer(:json_multiple, Whisperer::Serializers::JsonMultiple)

Whisperer.register_preprocessor(:content_length, Whisperer::Preprocessors::ContentLength)