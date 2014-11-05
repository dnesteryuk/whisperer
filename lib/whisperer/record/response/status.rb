module Whisperer
  class Status
    include Virtus.model

    attribute :code,    Integer, default: 200
    attribute :message, String,  default: 'OK'
  end # class Status
end # module Whisperer