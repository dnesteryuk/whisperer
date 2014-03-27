1. Create rake task for generating factories based on Vcr responses.
2. Make sure that generated fixtures supports ERB.
3. Find a way to avoid extending objects in runtime.
4. Think about unit tests for Whisperer module
5. Add code to calculate content length automatically
6. Add code to generate classes for models in runtime
7. Think about writing tests for Whisperer::Config
8. Try to find better way for defining dynamic attributes for headers, it doesn't work when you write:

```ruby
  Whisperer::Record.new(
    response: {
      headers: {
        content_length: 10
      }
    }
  )
```