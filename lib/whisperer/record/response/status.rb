module Whisperer
  class Response
    class Status
      include Virtus.model

      attribute :code,    Integer, default: proc { DefaultValue.new(200) }
      attribute :message, String,  default: proc { DefaultValue.new('OK') }
    end # class Status
  end # class Response
end # module Whisperer