## Release 0.0.2

1. In most cases if we have a serializer for one single factory, we need a serializer for multiple factories as well. We need to write code which will create a multiple serializer automatically.
2. The Whisperer::Config.load method is too complex.
3. Refactore Whisperer.define method, it is another responsibility which should not leave in this module.
4. Think about the issue with touching Whisperer::cassette_records in tests, it is not ok
5. Check whether we can use a real model instead of OpenStruct while describing factories.
6. Check the situation when we have `parent -> parent -> child` during inheritance.
7. Add info to doc:
  - factories for requests
8. Add the info to the doc about default values for cassettes and automatically calculated content length.
9. Add the info about creating own preprocessors.

## Release 0.1.0

1. Create rake task for generating factories based on Vcr responses.
2. Find the way to disable altering the existing cassettes by VCR while launching tests.