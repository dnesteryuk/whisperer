require 'whisperer/version'

require 'virtus'
require 'vcr'

require 'whisperer/dsl'
require 'whisperer/dsl/request'
require 'whisperer/dsl/response'
require 'whisperer/serializers/hash'

module Whisperer
  @factories = {}

  class << self
    attr_reader :factories

    def define(name, &block)
      dsl = Dsl.build
      dsl.instance_eval &block

      factories[name] = dsl.container
    end

    def generate(name)
      unless factories[name]
        raise ArgumentError.new("There are not factory with \"#{name}\" name")
      end

      container = factories[name]

      serializer = Whisperer::Serializers::Hash.new(container)
      hash = serializer.serialize

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
  end
end
