Whisperer.define(:my_fixture_builder) do
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
      factory  'my_factory', :json
    end
  end

  recorded_at Time.new
end