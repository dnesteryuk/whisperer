require 'spec_helper'

describe Whisperer do
  describe '.define' do
    let(:dsl) { instance_double('Whisperer::Dsl', container: 'some test') }

    before do
      Whisperer::Dsl.stub(:build).and_return(dsl)
    end

    it 'builds the dsl object' do
      expect(Whisperer::Dsl).to receive(:build)

      described_class.define(:test) {}
    end

    it 'executes a given block over the dsl object' do
      expect(dsl).to receive(:header)

      described_class.define(:test) {
        header
      }
    end
  end

  describe '.generate' do
    context 'when there is not such factory' do
      it 'raises an error' do
        expect { described_class.generate(:mytest) }.to raise_error(
          ArgumentError,
          'There is not factory with "mytest" name'
        )
      end
    end
  end

  describe '.serializer' do
    context 'when there is not such serializer' do
      it 'raises an error' do
        expect { described_class.serializer(:mytest) }.to raise_error(
          ArgumentError,
          'There is not serializer registered with "mytest" name'
        )
      end
    end

    context 'when there is such serializer' do
      it 'returns the registered class' do
        expect(described_class.serializer(:json)).to eq(Whisperer::Serializers::Json)
      end
    end
  end
end