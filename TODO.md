## Release 0.0.1

1. Make sure that generated fixtures supports ERB.
2. Think about unit tests for Whisperer module
3. Add possibility to set a default serializer for a fixture record
4. Whisperer#generate must be refactored
5. Add info to doc:
  - subpath for generating fixtures

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

6. Refactore Whisperer::Record#merge_attrs! method, it should be moved to some another class
