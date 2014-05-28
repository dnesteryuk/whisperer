require 'spec_integration_helper'

describe 'Whisperer' do
  after do
    Dir["#{VCR.configuration.cassette_library_dir}/**/*.yml"].each do |file|
      File.delete(file)
    end
  end

  context 'when a simple factory is given' do
    it 'generates a fixture' do
      expect(fixture('robb_stark')).to eq(Whisperer.generate(:robb_stark))
    end
  end

  context 'when an array of factories is given' do
    it 'generates a fixture' do
      expect(fixture('starks')).to eq(Whisperer.generate(:starks))
    end
  end

  context 'when a fixture record inherits another fixture record' do
    it 'generates a fixture with data from a parent fixture' do
      expect(fixture('wolfs')).to eq(Whisperer.generate(:wolfs))
    end
  end

  context 'when a fixture record is given without a defined content length for a response body' do
    it 'generates a fixture with a content length which is calculated by size of a response body' do
      expect(fixture('robb_stark_without_content_length')).to eq(
        Whisperer.generate(:robb_stark_without_content_length)
      )
    end
  end

  context 'when a fixture record use a string to define a response body' do
    it 'generates a fixture' do
      expect(fixture('empty_robb_stark')).to eq(Whisperer.generate(:empty_robb_stark))
    end
  end

  context 'when a fixture record has a sub directory' do
    it 'generates a fixture in a sub directory' do
      expect(fixture('girls/arya_stark')).to eq(Whisperer.generate(:arya_stark))
    end
  end
end