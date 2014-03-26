require_relative 'headers'
require_relative 'body'

module Whisperer
  class Request
    include Virtus.model

    attribute :uri,     String
    attribute :method,  Symbol
    attribute :headers, Whisperer::Headers, default: proc {
      header = Whisperer::Headers.new
      header.extend(Virtus.model)
      header
    }

    attribute :body, Whisperer::Body, default: proc { Whisperer::Body.new }
  end # class Request
end # module Whisperer