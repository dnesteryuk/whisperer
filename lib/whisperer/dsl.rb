require_relative 'dsl/base'

require_relative 'record'

module Whisperer
  class Dsl < BaseDsl
    link_container_class Whisperer::Record

    link_dsl 'request'
    link_dsl 'response'

    add_writer 'recorded_at'

    add_writer 'sub_path'
  end # class Dsl
end # module Whisperer

require 'whisperer/dsl/request'
require 'whisperer/dsl/response'