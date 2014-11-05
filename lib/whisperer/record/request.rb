require_relative 'headers'
require_relative 'body'

module Whisperer
  class Request
    include Virtus.model

    attribute :uri,     String
    attribute :method,  Symbol
    attribute :headers, Whisperer::Headers, default: proc {
      Whisperer::Headers.new
    }

    attribute :body, Body, default: proc { Body.new }
  end # class Request
end # module Whisperer