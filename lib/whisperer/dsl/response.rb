require_relative 'base'

require_relative 'headers'
require_relative 'body'
require_relative 'response/status'

module Whisperer
  class Dsl
    class Response < BaseDsl
      link_dsl 'headers'
      link_dsl 'body'
      link_dsl 'status'
    end # class Response
  end # class Dsl
end # module Whisperer