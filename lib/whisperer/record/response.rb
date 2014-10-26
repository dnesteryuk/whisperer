require_relative 'headers'
require_relative 'body'
require_relative 'response/status'

module Whisperer
  class Response
    include Virtus.model

    attribute :headers, Whisperer::Headers, default: proc {
      header = Whisperer::Headers.new
      header.attribute(:content_length, String)
      header
    }

    attribute :body,    Whisperer::Body,    default: proc { Whisperer::Body.new }
    attribute :status,  Whisperer::Status,  default: proc { Whisperer::Status.new }
  end # class Response
end # module Whisperer