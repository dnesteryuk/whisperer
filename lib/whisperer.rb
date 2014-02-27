require 'whisperer/version'

require 'virtus'
require 'vcr'

require 'whisperer/dsl'
require 'whisperer/dsl/request'
require 'whisperer/dsl/response'

require 'whisperer/convertors/hash'

require 'whisperer/serializers/json'

module Whisperer
  @factories   = {}
  @serializers = {}

  class << self
    attr_reader :factories
    attr_reader :serializers

    def define(name, &block)
      dsl = Dsl.build
      dsl.instance_eval &block

      factories[name] = dsl.container
    end

    def generate(name)
      unless factories[name]
        raise ArgumentError.new("There is not factory with \"#{name}\" name")
      end

      container = factories[name]

      convertor = Whisperer::Convertors::Hash.new(container)
      hash = convertor.convert

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
      factories.each do |name, container|
        generate(name)
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
end


Whisperer.register_serializer(:json, Whisperer::Serializers::Json)