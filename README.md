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

TODO: Write usage instructions here

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
