require_relative 'bran_stark'

Whisperer.define(:sansa_stark, parent: :bran_stark) do
  response do
    body do
      factory 'sansa_stark'
    end
  end
end