# Whisperer

[![Code Climate](https://codeclimate.com/github/dnesteryuk/whisperer/badges/gpa.svg)](https://codeclimate.com/github/dnesteryuk/whisperer)
[![Build Status](https://secure.travis-ci.org/dnesteryuk/whisperer.png?branch=master)](https://travis-ci.org/dnesteryuk/whisperer)
[![Dependency Status](https://gemnasium.com/dnesteryuk/whisperer.png)](https://gemnasium.com/dnesteryuk/whisperer)

Do you hate fixtures? I do as well. The purpose of this library is to make your life easier when your application works with external API and you use VCR to stub that API.

## Installation

**Requirments**:
 - Ruby 2.0.x or 2.1.x

Add this line to your application's Gemfile:

    gem 'whisperer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install whisperer

To create default directories' structure and the config file with default options, you need to execute:

    $ rake whisperer:install

It will create `cassette_builders` directory in your `spec` folder and `.whisperer.yml` file in your root directory of the project.

If you want to create only the config file, you need to execute:

    $ rake whisperer:config:create

## Usage

### Describing VCR cassettes

VCR cassettes are described in `cassette builders`. It is Ruby DSL which repeats structure of VCR cassette:

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

But, it is Ruby, hence, we can benefit from that. Whisperer uses [FactoryGirl](/thoughtbot/factory_girl) to describe a response body. If you are not familar with FactoryGirl, please, make sure, you know how to use it bofore going on. There are a few ways how factories can be used.

You can use one single factory:

```ruby
body do
  factory 'arya_stark' # we provide only name of the factory
end
```

`arya_stark` factory is taken to generate the response body:

```
string: '{"first_name":"Arya","last_name":"Stark","group":"member"}'
```

You can use multiple factories to generate collection for your response:

```ruby
body do
  factories ['robb_stark', 'ned_stark'] # again we provide only names of factories
end
```

`robb_stark` and `ned_stark` are taken to generate the response body:

```
string: '[{"first_name":"Robb","last_name":"Stark","group":"member"},{"first_name":"Ned","last_name":"Stark","group":"member"}]'
```

You can pass factory objects instead of their names:

```ruby
body do
  factories = (1..20).to_a.map do |i|
    factories << FactoryGirl.build(
      :article,
      id:      'testid' + i,
      title:   'test name' + i,
      body:    'desc' + i
    )
  end

  raw_data factories, :json_multiple
end
```

It is very useful, when you need generate dynamically instances of a factory.

#### Inheritance in cassette builders

If you need to generate almost the same VCR cassette, but with a bit different data, you can do it via inheritance:

```ruby
Whisperer.define(:robb_stark, parent: :arya_stark) do
  response do
    body do
      factory :robb_stark
    end
  end
end
```

In this case all data is taken from `aray_stark` cassette builder, only the response body is different.

You can redefine any option of VCR cassette:

```ruby
Whisperer.define(:robb_stark, parent: :arya_stark) do
  request do
    uri 'http://example.com/users/10'
  end
end
```

#### Request/Response Headers

While describing headers for a request or response you can use any kind of headers, they are dynamically created:

```ruby
  headers do
    content_length    100
    content_type     'application/json'
    x_requested_with 'XMLHttpRequest'
  end
```

In a cassette it will look like:

```
  Content-Length:
    - '100'
  Content-Type:
    - application/json
  X-Requested-With
    - XMLHttpRequest
```

#### Placeholder for FactoryGirl

Since VCR is used to stub interractions with external services, there is a big chance that you don't have Ruby model to be used for defining factories. In most cases, you don't need them to generate VCR cassettes. Whisperer offers the placeholder class:

```ruby
  FactoryGirl.define do
    factory :arya_stark, class: Placeholder do
      first_name 'Arya'
      last_name  'Stark'
      group      'member'
    end
  end
```

Placeholder is a simple class inheriting `OpenStruct` class:

```ruby
  Placeholder = Class.new(OpenStruct)
```

It decouples factories from your application.

### Serializers for a response body

When an external API is subbed with VCR, API response has some format like Json, XML or any other formats. Whisperer supports possibility to convert factories into a format your external API uses. Such mechanism is provided by **serializers** which are used along with building a response body. Whisperer has only 2 serializers:

 - json
 - multiple json

`Json` serializer is used for serializing one single factory:

```ruby
  response do
    body do
      factory    :robb_stark
      serializer :json
    end
  end
```

The purpose of `json `serializer is to convert a given factory into Json format.

`Multiple Json` serializer is used for serializing a collection of factories:

```ruby
body do
  factories  ['robb_stark', 'ned_stark']
  serializer :json_multiple
end
```

It is very similar to `Json` serializer, but in this case it goes through the array, builds factories, serializes a received array of objects.

If you need to define your own serializer, it is very easy to do. At first you need to define your own serializer class inhering `Whisperer::Serializes::Base` class:

```ruby
  class MySerializer < Whisperer::Serializers::Base
    def serialize
      do_something_with(@obj)
    end
  end
```

*Note:* `@obj` is an `OpenStruct` instance in this example.

Then you need to register the new serializer:

```ruby
  Whisperer.register_serializer(:my_serializer, Serializers::MySerializer)
```

Now, it can be used as any other serializer:

```ruby
  response do
    body do
      factory    :robb_stark
      serializer :my_serializer
    end
  end
```

### Configuration

You can configure Whisperer through `.whisperer.yml` which should be created in a root directory of your project. It gives you following options:

 - generate_to - the path to save generated cassettes
 - builders_matcher - the pattern to find builders
 - factories_matcher - the pattern to find factories

Example of such file:

```
generate_to:       'spec/cassettes/vcr_cassettes/'
builders_matcher:  './spec/cassette_builders/**/*.rb'
factories_matcher: './spec/factories/*.rb'
```

### Generating cassettes

To generate cassettes based on cassette builders, you need to launch command:

    $ rake whisperer:cassettes:generate_all

This command will generate new cassettes and re-generate all existing cassettes for VCR.

To generate only one particular cassette, you can use this command

    $ rake whisperer:cassettes:generate[cassette_builder]

`cassette_builder` is a name of the cassette builder.

### Generating a sample for the cassette builder

Manual creation of cassette builders is painful. There is a command which can help you with that:

    $ rake whisperer:cassettes:builders:sample

It creates a sample for you in the directory with cassette builders, you need to edit it only.

## Code examples

There is a repository with [examples](https://github.com/dnesteryuk/whisperer_example) of the Whisperer gem usage. It will help you to start using it.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
