require_relative '../request'
require_relative 'base'
require_relative 'header'
require_relative 'body'

module Whisperer
  class Dsl
    class Request < BaseDsl
      link_dsl 'header'
      link_dsl 'body'

      add_writer 'uri'
      add_writer 'method'
    end # class Request
  end # module Dsl
end # module Whisperer