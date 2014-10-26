## Release 0.0.1

1. Create rake task for generating factories based on Vcr responses.
2. Make sure that generated fixtures supports ERB.
3. Find a way to avoid extending objects in runtime.
4. Think about unit tests for Whisperer module
5. Think about writing tests for Whisperer::Config
6. Try to find better way for defining dynamic attributes for headers, it doesn't work when you write:

  ```ruby
    Whisperer::Record.new(
      response: {
        headers: {
          content_length: 10
        }
      }
    )
  ```

7. Refactore Whisperer::Record#merge_attrs! method, it should be moved to some another class
8. Write documentation about custom settings
9. Add possibility to set a default serializer for a fixture record
10. Whisperer#generate must be refactored
11. Add info to doc:
  - serializers
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