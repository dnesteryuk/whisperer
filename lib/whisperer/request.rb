require_relative 'header'
require_relative 'body'

module Whisperer
  class Request
    include Virtus.model

    attribute :uri,    String
    attribute :method, Symbol
    attribute :header, Whisperer::Header
    attribute :body,   Whisperer::Body
  end # class Request
end # module Whisperer