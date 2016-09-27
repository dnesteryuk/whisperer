# Whisperer

[![Code Climate](https://codeclimate.com/github/dnesteryuk/whisperer/badges/gpa.svg)](https://codeclimate.com/github/dnesteryuk/whisperer)
[![Build Status](https://secure.travis-ci.org/dnesteryuk/whisperer.png?branch=master)](https://travis-ci.org/dnesteryuk/whisperer)
[![Dependency Status](https://gemnasium.com/dnesteryuk/whisperer.png)](https://gemnasium.com/dnesteryuk/whisperer)

Do you hate fixtures? I do as well. The purpose of this library is to make your life easier when your application works with an external API and you use VCR to stub that API.

## Features

 - Describes VCR cassettes with Ruby.
 - Describes entities for the response body of VCR cassettes with [FactoryGirl](/thoughtbot/factory_girl).
 - Possibility to inherit VCR cassettes (actually cassette builders describing VCR cassettes, but the effect is the same).
 - Serializers to serialize a response body to a format supported by your API.

## Installation

**Requirements**:
 - Ruby 2.0.x or 2.1.x

Add this line to your application's Gemfile:

    gem 'whisperer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install whisperer

To create the default directory structure and a config file with default options, execute:

    $ rake whisperer:install

It will create a `cassette_builders` directory in your `spec` folder and a `.whisperer.yml` file in the root directory of your project.

If you want to create the config file only, execute:

    $ rake whisperer:config:create

## Usage

### Describing VCR cassettes

VCR cassettes are described in `cassette builders` using a Ruby DSL which repeats the structure of a VCR cassette:

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
      factory  'arya_stark'
    end
  end

  recorded_at 'Mon, 13 Jan 2014 21:01:47 GMT'
end
```

Since this DSL is Ruby, we can benefit from that. Whisperer uses [FactoryGirl](/thoughtbot/factory_girl) to describe a response body. If you are not familar with FactoryGirl, please make sure you know how to use it before going on. There are a few ways factories can be used:

You can use one single factory:

```ruby
body do
  factory 'arya_stark' # we provide only name of the factory
end
```

`arya_stark` factory is used to generate the response body:

```
string: '{"first_name":"Arya","last_name":"Stark","group":"member"}'
```

You can use multiple factories to generate a collection for your response:

```ruby
body do
  factories ['robb_stark', 'ned_stark'] # again we provide only names of factories
  serializer :json_multiple
end
```

`robb_stark` and `ned_stark` are used to generate the response body:

```
string: '[{"first_name":"Robb","last_name":"Stark","group":"member"},{"first_name":"Ned","last_name":"Stark","group":"member"}]'
```

You can pass factory objects instead of their names (useful when you need to dynamically generate instances of a factory):

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

  raw_data factories
  serializer :json_multiple
end
```

#### Inheritance in cassette builders

If you need to generate almost the same VCR cassette, but with slightly different data, you can do it via inheritance:

```ruby
Whisperer.define(:robb_stark, parent: :arya_stark) do
  response do
    body do
      factory :robb_stark
    end
  end
end
```

In this case, all the data is taken from the `arya_stark` cassette builder, except for the specified response body.

You can redefine any option of a VCR cassette you are inheriting from:

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

Since VCR is used to stub interactions with external services, there is a big chance that you won't have a Ruby model to be used for defining factories. In most cases, you don't need them to generate VCR cassettes. Whisperer offers the placeholder class:

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

**Note:** If you use your own models instead of `OpenStruct` objects for defining factories, you have to implement an `attributes` method returning a hash with attributes for your models. Otherwise, the serializers provided by this gem will use all instance variables of your models for serializing them.

### Serializers for a response body

When an external API is stubbed with VCR, the API response has some format like JSON, XML or any other formats. Whisperer supports converting factories into the format your external API uses. This mechanism is provided by **serializers** which are used along with building a response body. Whisperer has 2 built-in serializers:

 - json
 - json_multiple

The `json` serializer is used for serializing one single factory:

```ruby
  response do
    body do
      factory    :robb_stark
      serializer :json
    end
  end
```

The purpose of the `json` serializer is to convert a given factory into JSON format.

The `json_multiple` serializer is used for serializing a collection of factories:

```ruby
body do
  factories  ['robb_stark', 'ned_stark']
  serializer :json_multiple
end
```

It is very similar to the `json` serializer, but in this case it goes through the array of factories, builds each factory, serializes the received objects, and returns them as an array.

If you need to define your own serializer, it is very easy to do. First, you need to define your own serializer class inheriting the `Whisperer::Serializes::Base` class:

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

Now it can be used as any other serializer:

```ruby
  response do
    body do
      factory    :robb_stark
      serializer :my_serializer
    end
  end
```

### Sub directories to save cassettes

By default all generated cassettes are saved in one directory. This can be inconvenient when you have a lot of cassettes there. Therefore, there is an option to define your own subpath in a cassette builder, that subpath will be used for saving a cassette:

```ruby
Whisperer.define(:robb_stark) do
  response do
    body do
      factory 'robb_stark'
    end
  end

  sub_path 'starks'
end
```

If you don't change the path to your cassette, the cassette from the example will be saved in `spec/cassettes/vcr_cassettes/starks` directory. It helps you to structure your cassettes.

### Default values of cassette builders

There are attributes which you can omit and the gem will provide default values for them. All values listed in the following example are default and you can omit them:

```ruby
  Whisperer.define(:arya_stark) do
    request do
      method :get
      
      body do
        encoding 'UTF-8'
        string   '' 
      end
    end
  
    response do
      status do
        code    200
        message 'OK'
      end

      body do
        encoding   'UTF-8'
        serializer :json
      end
    end
  end
```

Also, there are attributes which are automatically calculated if you don't specify values for them:

 - **recorded_at** - it gets a date of generating a cassette;
 - **content_length** header of a response` - the gem calculates this value based on a response body.

### Configuration

You can configure Whisperer through `.whisperer.yml` which should be created in a root directory of your project. It gives you the following options:

 - **generate_to** - the path to save generated cassettes
 - **builders_matcher** - the pattern to find builders
 - **factories_matcher** - the pattern to find factories

Example of `.whisperer.yml`:

```
generate_to:       'spec/cassettes/vcr_cassettes/'
builders_matcher:  './spec/cassette_builders/**/*.rb'
factories_matcher: './spec/factories/*.rb'
```

### Generating cassettes

To generate cassettes based on cassette builders, you need to launch the command:

    $ rake whisperer:cassettes:generate_all

This command will generate new cassettes and re-generate all existing cassettes for VCR.

To generate one particular cassette, you can use this command

    $ rake whisperer:cassettes:generate[cassette_builder]

`cassette_builder` is a name of the cassette builder.

### Generating a sample for the cassette builder

Manual creation of cassette builders is painful. There is a command which can help you with that:

    $ rake whisperer:cassettes:builders:sample

It creates a sample for you in the directory with cassette builders, you need to edit it only.

## Code examples

There is a repository with [examples](https://github.com/dnesteryuk/whisperer_example) of the Whisperer gem usage. It will help you to start using it.

## Resources

[Introduction into Whisperer](http://nesteryuk.info/2014/11/16/whisperer-introduction.html)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
