## Release 0.0.2

1. In most cases if we have a serializer for one single factory, we need a serializer for multiple factories as well. We need to write code which will create a multiple serializer automatically.
2. The Whisperer::Config.load method is too complex.
3. Add info to doc:
  - factories for requests
4. Add the info about creating own preprocessors.

## Release 0.1.0

1. Create rake task for generating factories based on Vcr responses.
2. Find the way to disable altering the existing cassettes by VCR while launching tests.
3. Add a helper method to generate a collection of factories to avoid such code:

  ```ruby
      factory = FactoryGirl.build(:event)

      factories = [factory]

      6.times do |t|
        i = (t + 2).to_s

        factories << FactoryGirl.build(
          :event,
          id: factory.id + i

        )
      end
  ```
which is duplicated in a few builders.
4. Default record which will be used only for inheriting, something:

  ```ruby
    Whisperer.define(:default_for_my_api) do
    end
  ```

  it won't be used for generating a cassette, only for inheriting.
5. Add DSL which will allow us to define any helper method for the body DSL. It should allow our users to extend functionality of the gem.
6. Add DSL to define the way how we can read attributes from models which are used in factories if it is not `OpenStruct` model.
7. `Whisperer::Serializers::Json#fetch_attrs` method should be extracted to own class since it may be useful for a custom serializers.
