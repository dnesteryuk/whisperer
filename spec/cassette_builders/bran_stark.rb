Whisperer.define(:bran_stark) do
  request do
    uri    'http://example.com/users/2'
    method :get

    headers do
      accept '*/*'
    end
  end

  response do
    body do
      serializer :custom
      factory    'bran_stark'
    end
  end

  recorded_at 'Mon, 13 Jan 2014 21:01:47 GMT'
end