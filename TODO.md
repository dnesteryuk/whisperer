1. Create rake task for generating factories based on Vcr responses.
2. Make sure that generated fixtures supports ERB.
3. Find a way to avoid extending objects in runtime.
4. Think about unit tests for Whisperer#generate, Whisperer#register_serializer method
5. Add code to calculate content length automatically
6. Add code to generate classes for models in runtime
7. Add code to specify path for generating fixtures, but it should have default
8. recorded_at field should be generated automatically.
9. Configuration for Vcr should not be defined in whisperer.rake