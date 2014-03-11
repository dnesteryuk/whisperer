require 'whisperer'
require 'factory_girl'
require 'rainbow'

User = Class.new(OpenStruct)

Dir[
  './spec/factories/**/*.rb',
  './spec/fixture_builders/**/*.rb'
].each {|f| require f }

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures'
end

namespace :whisperer do
  desc 'Takes all fixture builders and generates fixtures for VCR'
  task :generate_all do
    if Whisperer.defined_any?
      Whisperer.generate_all

      puts Rainbow('Fixtures are generated').green
    else
      puts Rainbow('Any fixture builder was found. Please, make sure you define at least one.').yellow
    end
  end

  desc 'Takes a specific fixture builder and generates one specific fixture for VCR'
  task :generate, :name do |t, args|
    name = args[:name]

    begin
      Whisperer::generate(name)

      puts Rainbow("The fixture '#{name}' is generated").green
    rescue Whisperer::NoFixtureBuilderError => error
      puts Rainbow(error.message).red
    end
  end
end