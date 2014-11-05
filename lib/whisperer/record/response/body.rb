require_relative '../body'

module Whisperer
  class Response
    class Body < Whisperer::Body
      # Attributes which are not part of Vcr response
      attribute :data_obj,         Object
      attribute :serializer,       Symbol, default: proc { :json }
      attribute :serializer_opts,  Hash,   default: {}
    end
  end
end