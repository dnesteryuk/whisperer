Whisperer.define(:robb_stark) do
  request do
    uri    'http://example.com/users/1'
    method :get

    headers do
      accept '*/*'
    end
  end

  response do
    status do
      code    200
      message 'OK'
    end

    headers do
      content_type           'application/json;charset=utf-8'
      content_length         57
      x_content_type_options 'nosniff'
    end

    body do
      encoding 'UTF-8'
      factory  'robb_stark'
    end
  end

  recorded_at 'Mon, 13 Jan 2014 21:01:47 GMT'
end