require 'spec_helper'

require 'factory_girl'

Dir[
  './spec/factories/**/*.rb',
  './spec/fixture_builders/**/*.rb'
].each {|f| require f }
