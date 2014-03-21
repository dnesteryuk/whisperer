require 'whisperer/version'

require 'virtus'
require 'vcr'

require 'whisperer/dsl'
require 'whisperer/dsl/request'
require 'whisperer/dsl/response'

require 'whisperer/convertors/hash'

require 'whisperer/serializers/json'

module Whisperer
  @fixture_builders = ThreadSafe::Hash.new
  @serializers      = ThreadSafe::Hash.new

  class << self
    attr_reader :fixture_builders
    attr_reader :serializers

    def define(name, options = {}, &block)
      dsl = Dsl.build
      dsl.instance_eval &block
      record = dsl.container

      if options[:parent]
        original_record = fixture_builders[options[:parent]]

        if original_record.nil?
          raise ArgumentError.new("Parent record with \"#{options[:parent]}\" is not declired.")
        else
          record.merge!(original_record)
        end
      end

      fixture_builders[name.to_sym] = record
    end

    # Returns true if at least one factory is defined, otherwise returns false.
    def defined_any?
      fixture_builders.size > 0
    end

    def generate(name)
      name = name.to_sym

      unless fixture_builders[name]
        raise NoFixtureBuilderError.new("There is not fixture builder with \"#{name}\" name.")
      end

      container = fixture_builders[name]

      hash = Whisperer::Convertors::Hash.convert(container)

      hash['recorded_at'] = 'Mon, 13 Jan 2014 21:01:47 GMT'

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
        fixture_builders.each do |name, container|
          generate(name)
        end
      else
        raise NoFixtureBuilderError.new('Fixture builders are not found.')
      end
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

  class NoFixtureBuilderError < ArgumentError; end
end


Whisperer.register_serializer(:json, Whisperer::Serializers::Json)