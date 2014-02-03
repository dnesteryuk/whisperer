require_relative 'header'
require_relative 'body'

module Whisperer
  class Response
    include Virtus.model

    attribute :header, Whisperer::Header
    attribute :body,   Whisperer::Body
  end # class Response
end # module Whisperer