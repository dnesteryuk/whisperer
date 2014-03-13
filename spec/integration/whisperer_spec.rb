require 'spec_integration_helper'

describe 'Whisperer' do
  after do
    Dir["#{VCR.configuration.cassette_library_dir}/*.yml"].each do |file|
      File.delete(file)
    end
  end

  context 'when a simple factory is given' do
    it 'generates a fixture' do
      expect(fixture('robb_stark')).to eq(Whisperer.generate(:robb_stark))
    end
  end

  context 'when an array factories are given' do
    it 'generates a fixture' do
      expect(fixture('starks')).to eq(Whisperer.generate(:starks))
    end
  end

  context 'when a fixture builder inherits another fixture builder' do
    it 'generates a fixture with data from a parent fixture' do
      expect(fixture('wolfs')).to eq(Whisperer.generate(:wolfs))
    end
  end
end