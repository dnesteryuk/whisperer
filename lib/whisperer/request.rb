require_relative 'header'

module Whisperer
  class Request
    include Virtus.model

    attribute :uri,    String
    attribute :method, Symbol
    attribute :header, Whisperer::Header
  end # class Request
end # module Whisperer