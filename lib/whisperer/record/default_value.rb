module Whisperer
  class DefaultValue
    def initialize(val)
      @val = val
    end

    def is_default; true; end

    def to_sym; @val; end

    def to_default; @val; end
  end
end