require 'spec_integration_helper'

describe 'Whisperer' do
  after do
    Dir["#{VCR.configuration.cassette_library_dir}/**/*.yml"].each do |file|
      File.delete(file)
    end
  end

  context 'when a simple factory is given' do
    it 'generates a cassette' do
      expect(cassette('robb_stark')).to eq(Whisperer.generate(:robb_stark))
    end
  end

  context 'when an array of factories is given' do
    it 'generates a cassette' do
      expect(cassette('starks')).to eq(Whisperer.generate(:starks))
    end
  end

  context 'when a cassette record inherits another cassette record' do
    it 'generates a cassette with data from a parent cassette' do
      expect(cassette('wolfs')).to eq(Whisperer.generate(:wolfs))
    end
  end

  context 'when a cassette record is given without a defined content length for a response body' do
    it 'generates a cassette with a content length which is calculated by size of a response body' do
      expect(cassette('robb_stark_without_content_length')).to eq(
        Whisperer.generate(:robb_stark_without_content_length)
      )
    end
  end

  context 'when a cassette record use a string to define a response body' do
    it 'generates a cassette' do
      expect(cassette('empty_robb_stark')).to eq(Whisperer.generate(:empty_robb_stark))
    end
  end

  context 'when a cassette record has a sub directory' do
    it 'generates a cassette in a sub directory' do
      expect(cassette('girls/arya_stark')).to eq(Whisperer.generate(:arya_stark))
    end
  end
end