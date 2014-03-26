module Whisperer
  class Body
    include Virtus.model

    attribute :encoding, String
    attribute :string,   String
  end # class Body
end # module Whisperer