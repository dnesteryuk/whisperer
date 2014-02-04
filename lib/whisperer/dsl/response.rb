require_relative '../response'
require_relative 'base'

require_relative 'header'
require_relative 'body'
require_relative 'status'

module Whisperer
  class Dsl
    class Response < BaseDsl
      link_container_class Whisperer::Response

      link_dsl 'header'
      link_dsl 'body'
      link_dsl 'status'
    end # class Response
  end # class Dsl
end # module Whisperer