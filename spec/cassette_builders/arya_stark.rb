Whisperer.define(:arya_stark) do
  request do
    uri    'http://example.com/users/1'
    method :get
  end

  response do
    status do
      code    200
      message 'OK'
    end

    headers do
      content_type 'application/json;charset=utf-8'
    end

    body do
      encoding 'UTF-8'
      factory  'arya_stark'
    end
  end

  recorded_at 'Mon, 13 Jan 2014 21:01:47 GMT'

  sub_path 'girls'
end