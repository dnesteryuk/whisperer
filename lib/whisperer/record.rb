require_relative 'record/request'
require_relative 'record/response'

module Whisperer
  class Record
    include Virtus.model

    attribute :request,      Whisperer::Request,  default: proc { Whisperer::Request.new }
    attribute :response,     Whisperer::Response, default: proc { Whisperer::Response.new }
    attribute :http_version, String, default: ''
    attribute :recorded_at,  String, default: proc { Time.now.httpdate }
    attribute :sub_path,     String
  end # class Record
end # module Whisperer