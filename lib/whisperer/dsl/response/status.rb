require_relative '../base'

module Whisperer
  class Dsl
    class Status < BaseDsl
      add_writer 'message'
      add_writer 'code'
    end # class Status
  end # class Dsl
end # module Whisperer