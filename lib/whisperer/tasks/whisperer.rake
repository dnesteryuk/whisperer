require 'whisperer'
require 'whisperer/config'

require 'active_support/core_ext/hash/deep_merge'
require 'factory_girl'
require 'rainbow'
require 'yaml'

config = Whisperer::Config.load('.whisperer.yml')

Dir[
  config.factories_matcher,
  config.builders_matcher
].each {|f| require f }

namespace :whisperer do
  desc 'Takes all fixture builders and generates fixtures for VCR'
  task :generate_all do
    begin
      Whisperer.generate_all

      puts Rainbow('Fixtures are generated').green
    rescue Whisperer::NoFixtureRecordError => error
      puts Rainbow("Any fixture builder was found. Please, make sure you define at least one (We are looking for it like: #{config.builders_matcher}).").yellow
    end
  end

  desc 'Takes a specific fixture builder and generates one specific fixture for VCR'
  task :generate, :name do |t, args|
    name = args[:name]

    begin
      Whisperer::generate(name)

      puts Rainbow("The fixture '#{name}' is generated").green
    rescue Whisperer::NoFixtureRecordError => error
      puts Rainbow(error.message).red
    end
  end
end