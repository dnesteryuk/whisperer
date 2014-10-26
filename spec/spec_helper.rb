require 'bundler/setup'

require 'ostruct'

require 'rspec'
require 'factory_girl'

require 'whisperer'

require 'support/fixtures'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include(Fixtures)
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/generated_fixtures'
end