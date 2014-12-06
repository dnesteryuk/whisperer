require 'spec_helper'

describe Whisperer::Serializers do
  describe '.fetch' do
    before do
      described_class.register(:test_json, 'My test class')
    end

    context 'when there is not such serializer' do
      it 'raises an error' do
        expect { described_class.fetch(:mytest) }.to raise_error(
          ArgumentError,
          'There is not serializer registered with "mytest" name'
        )
      end
    end

    context 'when there is such serializer' do
      it 'returns the registered class' do
        expect(described_class.fetch(:test_json)).to eq('My test class')
      end
    end
  end
end