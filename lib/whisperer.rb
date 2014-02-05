require 'whisperer/version'

require 'virtus'

require 'whisperer/dsl'
require 'whisperer/dsl/request'
require 'whisperer/dsl/response'

module Whisperer
  @factories = {}

  class << self
    attr_reader :factories

    def define(name, &block)
      dsl = Dsl.build
      dsl.instance_eval &block

      factories[:name] = dsl.container
    end

    def generate(name)
    end
  end
end
