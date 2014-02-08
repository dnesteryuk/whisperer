require 'spec_integration_helper'

describe 'Whisperer' do
  after do
    Dir["#{VCR.configuration.cassette_library_dir}/*.yml"].each do |file|
      File.delete(file)
    end
  end

  it 'generates a simple fixture from an user factory' do
    expect(fixture('user')).to eq(Whisperer.generate(:user))
  end
end