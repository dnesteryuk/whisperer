# 0.0.2

  * fixed the bug with using the default values in child cassette builders when parent cassette builders overrided them.
  * internal improvements helping in developing new features.
  * improved documentation.
  * added default values:
    - `get` is a default method for a request;
    - `200` is a default status of a response;
    - `UTF-8` is a default encoding for a body of the request and response.
    - `json` is a default serializer.