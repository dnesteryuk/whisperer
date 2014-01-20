require 'bundler/setup'

require 'rspec'
require 'rspec/fire'

require 'whisperer'

Coveralls.wear!

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include(RSpec::Fire)
end
