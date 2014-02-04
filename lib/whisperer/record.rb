require_relative 'request'
require_relative 'response'

module Whisperer
  class Record
    include Virtus.model

    attribute :request,  Whisperer::Request
    attribute :response, Whisperer::Response
  end # class Record
end # module Whisperer