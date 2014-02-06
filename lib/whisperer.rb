require 'whisperer/version'

require 'virtus'

require 'whisperer/dsl'
require 'whisperer/dsl/request'
require 'whisperer/dsl/response'
require 'vcr'

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

      hash = container.to_hash
      hash['recorded_at'] = 'Mon, 13 Jan 2014 21:01:47 GMT'

      interaction = VCR::HTTPInteraction.from_hash(
        hash
      )

      cassette = VCR::Cassette.new(name)
      cassette.record_http_interaction(
        interaction
      )

      cassette.eject
    end
  end
end
