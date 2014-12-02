## Release 0.0.1

1. Add info to doc:
  - subpath for generating cassettes
  - factories for requests

## Release 0.0.2

1. Think about the better way for inheriting serializes, now it looks like:

  ```ruby
    class Whisperer::Serializers::Base
      # ...
    end

    class Whisperer::Serializers::Json < Whisperer::Serializers::Base
      # ...
    end

    class Whisperer::Serializers::JsonMultiple < Whisperer::Serializers::Json
      # ...
    end
  ```

  If an user wants to inherit `Whisperer::Serializers::JsonMultiple` it will look even more crazy.

2. In most cases if we have a serializer for one single factory, we need a serializer for multiple factories. We need to write code which will create a multiple serializer automatically.
3. The Whisperer::Config.load method is too complex.
4. Create rake task for generating factories based on Vcr responses.
5. Try to find better way for defining dynamic attributes for headers, it doesn't work when you write:

  ```ruby
    Whisperer::Record.new(
      response: {
        headers: {
          content_length: 10
        }
      }
    )
  ```

6. Refactore Whisperer.define method, it is another responsibility which should not leave in this module.
7. Think about the issue with touching Whisperer::cassette_records, it is not ok
8. `Whisperer::generate` and `Whisperer::generate_all` receive cassette records twice. Also, it is needless to check existence of a cassette record if it is passed from `generate_all` to `generate`.
9. Serializers must be stored similar to preprocessors (in the own module/class).
10. Check whether we can use a real model instead of OpenStruct while describing factories.