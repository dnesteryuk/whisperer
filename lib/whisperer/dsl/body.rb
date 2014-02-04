require_relative 'base'

module Whisperer
  class Dsl
    class Body < BaseDsl
      add_writer 'encoding'
      add_writer 'string'
    end # class Body
  end # class Dsl
end # module Whisperer