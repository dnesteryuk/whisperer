require 'spec_integration_helper'

describe 'Whisperer' do
  it 'generates a simple fixture from an user factory' do
    expect(fixture('user')).to eq(Whisperer.generate(:user))
  end
end