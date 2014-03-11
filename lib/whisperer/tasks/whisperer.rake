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
    Whisperer::generate_all

    puts Rainbow('Fixtures are generated').green
  end

  desc 'Takes a specific fixture builder and generates one specific fixture for VCR'
  task :generate, :name do |t, args|
    name = args[:name]

    Whisperer::generate(name)

    puts Rainbow("The fixture '#{name}' is generated").green
  end
end