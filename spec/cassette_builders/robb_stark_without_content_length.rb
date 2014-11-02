Whisperer.define(:robb_stark_without_content_length) do
  request do
    uri    'http://example.com/users/2'
    method :get
  end

  response do
    status do
      code    200
      message 'OK'
    end

    body do
      encoding 'UTF-8'
      factory  'robb_stark'
    end
  end

  recorded_at 'Mon, 13 Jan 2014 21:01:47 GMT'
end