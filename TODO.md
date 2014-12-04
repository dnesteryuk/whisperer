## Release 0.0.2

1. Think about the better way for inheriting serializers, now it looks like:

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

2. In most cases if we have a serializer for one single factory, we need a serializer for multiple factories as well. We need to write code which will create a multiple serializer automatically.
3. The Whisperer::Config.load method is too complex.
4. Try to find a better way for defining dynamic attributes for headers, it doesn't work when you write:

  ```ruby
    Whisperer::Record.new(
      response: {
        headers: {
          content_length: 10
        }
      }
    )
  ```

5. Refactore Whisperer.define method, it is another responsibility which should not leave in this module.
6. Think about the issue with touching Whisperer::cassette_records in tests, it is not ok
7. `Whisperer::generate` and `Whisperer::generate_all` receive cassette records twice. Also, it is needless to check existence of a cassette record if it is passed from `generate_all` to `generate`.
8. Serializers must be stored similar to preprocessors (in the own module/class).
9. Check whether we can use a real model instead of OpenStruct while describing factories.
10. Check the situation when we have `parent -> parent -> child` during inheritance.
11. Add info to doc:
  - factories for requests

## Release 0.1.0

1. Create rake task for generating factories based on Vcr responses.
2. Find the way to disable altering the existing cassettes by VCR while launching tests.