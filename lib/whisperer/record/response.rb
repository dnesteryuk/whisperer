require_relative 'headers'
require_relative 'body'
require_relative 'response/status'

module Whisperer
  class Response
    include Virtus.model

    attribute :headers, Headers, default: proc { Headers.new(content_length: nil) }
    attribute :body,    Body,    default: proc { Body.new }
    attribute :status,  Status,  default: proc { Status.new }
  end # class Response
end # module Whisperer