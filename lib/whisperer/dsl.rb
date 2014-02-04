require_relative 'dsl/base'

require_relative 'record'

module Whisperer
  class Dsl < BaseDsl
    link_container_class Whisperer::Record

    link_dsl 'request'
    link_dsl 'response'
  end # class Dsl
end # module Whisperer