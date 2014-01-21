require 'bundler/setup'

require 'rspec'
require 'rspec/fire'

require 'whisperer'

require 'support/fixtures'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include(RSpec::Fire)
  config.include(Fixtures)
end
