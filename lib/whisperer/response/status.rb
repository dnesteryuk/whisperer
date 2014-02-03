module Whisperer
  class Status
    include Virtus.model

    attribute :code,    Integer
    attribute :message, String
  end # class Status
end # module Whisperer