require 'spec_helper'

Dir[
  './spec/factories/**/*.rb',
  './spec/cassette_builders/**/*.rb'
].each {|f| require f }
