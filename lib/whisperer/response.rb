require_relative 'header'
require_relative 'body'
require_relative 'response/status'

module Whisperer
  class Response
    include Virtus.model

    attribute :header, Whisperer::Header
    attribute :body,   Whisperer::Body
    attribute :status, Whisperer::Status
  end # class Response
end # module Whisperer