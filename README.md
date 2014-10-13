# Whisperer

Do you hate fixtures? I do as well. The purpose of this library is to make your life much easier when your application works with external API and you have to create a lot of VCR fixtures.

## Installation

Add this line to your application's Gemfile:

    gem 'whisperer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install whisperer

## Usage

### Describing VCR fixtures

Whisperer is a tool to describe VCR fixture in a better way.

VCR fixtures are described in `fixture builders`, body of responses are described in `factories` (take a look at [FactoryGirl](/thoughtbot/factory_girl)). Example of fixture builder:

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

It is used to generate VCR fixture like this:

```yml
---
http_interactions:
- request:
    method: get
    uri: http://example.com/users/1
    body:
      encoding: US-ASCII
      string: ''
    headers: {}
  response:
    status:
      code: 200
      message: OK
    headers:
      Content-Length:
      - '58'
      Content-Type:
      - application/json;charset=utf-8
    body:
      encoding: UTF-8
      string: '{"first_name":"Arya","last_name":"Stark","group":"member"}'
    http_version:
  recorded_at: Mon, 13 Jan 2014 21:01:47 GMT
recorded_with: VCR 2.8.0
```

As we see structure of fixture builder is almost the same an output in Yaml. But, it smooths all problems of Yaml.

Also, to generare this fixture, `arya_stark` factory is used:

```ruby
FactoryGirl.define do
  factory :arya_stark, class: Placeholder do
    first_name 'Arya'
    last_name  'Stark'
    group      'member'
  end
end
```

#### Describing a response body

There are a few ways how you can define a body of the response.

You can use factory:

```ruby
  body do
    encoding 'UTF-8'
    factory  'arya_stark', :json
  end
```

In this case `arya_stark` factory is taken to generate VCR fixture.

If you need to use multiple fixtures you can use another DSL method:

```ruby
  body do
    encoding 'UTF-8'
    factories ['robb_stark', 'ned_stark'], :json_multiple
  end
```

`robb_stark` and `ned_stark` are taken to generate the response body:

```ruby
  string: '[{"first_name":"Robb","last_name":"Stark","group":"member"},{"first_name":"Ned","last_name":"Stark","group":"member"}]'
```

### Configuration

There is a posibility to configure Whisperer through `.whisperer.yml` which should be created in a root directory of your project. It will allow you to specify following options:

 - generate_to - path to save generated fixtures
 - builders_matcher - pattern to find builders
 - factories_matcher - pattern to find factories

Example of such file:

```
  generate_to:       '../fixtures/vcr_cassettes/'
  builders_matcher:  './fixture_builders/**/*.rb'
  factories_matcher: './factories/*.rb'
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
