Whisperer.define(:user) do
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
      content_type 'application/json;charset=utf-8'
    end

    body do
      encoding 'UTF-8'
      string FactoryGirl.build(:user)
    end
  end
end