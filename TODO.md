## Release 0.0.2

1. In most cases if we have a serializer for one single factory, we need a serializer for multiple factories as well. We need to write code which will create a multiple serializer automatically.
2. The Whisperer::Config.load method is too complex.
3. Try to find a better way for defining dynamic attributes for headers, it doesn't work when you write:

  ```ruby
    Whisperer::Record.new(
      response: {
        headers: {
          content_length: 10
        }
      }
    )
  ```

4. Refactore Whisperer.define method, it is another responsibility which should not leave in this module.
5. Think about the issue with touching Whisperer::cassette_records in tests, it is not ok
6. Check whether we can use a real model instead of OpenStruct while describing factories.
7. Check the situation when we have `parent -> parent -> child` during inheritance.
8. Add info to doc:
  - factories for requests

## Release 0.1.0

1. Create rake task for generating factories based on Vcr responses.
2. Find the way to disable altering the existing cassettes by VCR while launching tests.