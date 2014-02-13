require_relative 'request'
require_relative 'response'

module Whisperer
  class Record
    include Virtus.model

    attribute :request,      Whisperer::Request,  default: proc { Whisperer::Request.new }
    attribute :response,     Whisperer::Response, default: proc { Whisperer::Response.new }
    attribute :http_version, String, default: ''
  end # class Record
end # module Whisperer