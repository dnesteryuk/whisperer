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
10. The `prepare_data` method should allow to define the post processor in the serializers.
11. Add a rake task to generate a placeholder to define fixture builders.
12. Whisperer#generate must be refactored
13. Upgrade Rspec