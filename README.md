# Whisperer

Do you hate fixtures? I do as well. The purpose of this library is to make your life much easier when your application works with external API and you have to create a lot of VCR fixtures.

## Installation

Add this line to your application's Gemfile:

    gem 'whisperer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install whisperer

To create default directories' structure and the config file with default options, you need to execute:

    $ rake whisperer:install

It will create `fixture_builders` directory in your `spec` folder and `.whisperer.yml` file in your root directory of a project.

If you want to create only the config file, you need to execute:

    $ rake whisperer:create_config

## Usage

### Describing VCR fixtures

VCR fixtures are described in `fixture builders`. It is Ruby DSL which repeats structure of VCR fixture:

```ruby
Whisperer.define(:arya_stark) do
  request do
    uri    'http://example.com/users/1'
    method :get
  end

  response do
    status do
      code    200
      message 'OK'
    end

    headers do
      content_type 'application/json;charset=utf-8'
    end

    body do
      encoding 'UTF-8'
      factory  'arya_stark', :json
    end
  end

  recorded_at 'Mon, 13 Jan 2014 21:01:47 GMT'
end
```

But, it is Ruby, hence, we can benefit from that. Whisperer uses [FactoryGirl](/thoughtbot/factory_girl) to describe a response body. If you are not familar with FactoryGirl, please, make sure, you know how to use it bofore going on. There are a few way how factories can be used.

You can use one single factory:

```ruby
  body do
    factory 'arya_stark', :json # we provide only name of it
  end
```

`arya_stark` factory is taken to generate the response body:

```yml
  string: '{"first_name":"Arya","last_name":"Stark","group":"member"}'
```

You can use multiple factories to generate collection for your response:

```ruby
  body do
    factories ['robb_stark', 'ned_stark'], :json_multiple # again we provide only names of factories
  end
```

`robb_stark` and `ned_stark` are taken to generate the response body:

```ruby
  string: '[{"first_name":"Robb","last_name":"Stark","group":"member"},{"first_name":"Ned","last_name":"Stark","group":"member"}]'
```

You can pass factories instead of its name:

```ruby
  body do
    factories = []

    20.times do |t|
      factories << FactoryGirl.build(
        :people,
        id:          'testid' + i,
        name:        'test name' + i,
        description: 'desc' + i
      )
    end

    raw_data factories, :json_multiple, options: {size: 22}
  end
```

It is very useful, when you need dynamically generate instances of a factory.

#### Inheritance of fixture builders

If you need to generate almost the same VCR fixture, but with a bit differ data, you can do it via inheritance:

```ruby
  Whisperer.define(:robb_stark, parent: :arya_stark) do
    response do
      body do
        factory :robb_stark, :json
      end
    end
  end
```

In this case all data is taken from `aray_stark` fixture builder, only the response body is different. 

You can redefine any option of VCR fixture:

```ruby
  Whisperer.define(:robb_stark, parent: :arya_stark) do
    request do
      uri 'http://example.com/users/10'
    end
  end
```

### Configuration

You can configure Whisperer through `.whisperer.yml` which should be created in a root directory of your project. It gives you following options:

 - generate_to - the path to save generated fixtures
 - builders_matcher - the pattern to find builders
 - factories_matcher - the pattern to find factories

Example of such file:

```
  generate_to:       'spec/fixtures/vcr_cassettes/'
  builders_matcher:  './spec/fixture_builders/**/*.rb'
  factories_matcher: './spec/factories/*.rb'
```

### Generate fixtures

To generate fixtures based on fixture builders, you need to launch command:

```shell
  rake whisperer:generate_all
```

This command will generate new fixtures and re-generate all existing fixtures for VCR.

To generate only on particular fixture, you can use this command

```shell
  rake whisperer:generate[fixture_builder]
```

`fixture_builder` is a name of the fixture builder.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
