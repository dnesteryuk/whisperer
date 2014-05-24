require_relative 'starks'

Whisperer.define(:wolfs, parent: :starks) do
  request do
    uri 'http://example.com/members'
  end
end