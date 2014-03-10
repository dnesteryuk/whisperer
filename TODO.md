1. Create rake task for generating factories based on Vcr responses.
2. Make sure that generated fixtures supports ERB.
3. Find a way to avoid extending objects in runtime.
4. Think about unit tests for Whisperer#generate, Whisperer#register_serializer method
5. Add code to calculate content length automatically
6. Add posibility to inherit the defined factory builder
7. Add code to show warning when an user tries to generate all fixtures without any factory
8. Add code to generate classes for models in runtime
9. Add code to specify path for generating fixtures, but it should have default
10. Fix the issue with naming factories with symbols and strings, otherwise, when we generate a specific fixtures, it may not be found.