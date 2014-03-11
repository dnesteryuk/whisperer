require 'spec_helper'

describe Whisperer do
  after do
    described_class.fixture_builders.clear
  end

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

    it 'stores the generated factory' do
      described_class.define(:test) {}

      expect(Whisperer.fixture_builders[:test]).to eq('some test')
    end

    context 'when a string as a name of a fixture builder is given' do
      it 'stores a fixture builder with symbol key' do
        described_class.define('test') {}

        expect(Whisperer.fixture_builders[:test]).to eq('some test')
      end
    end
  end

  describe '.defined_any?' do
    context 'when there are defined fixture builders' do
      before do
        described_class.fixture_builders[:test] = true
      end

      it 'returns true' do
        expect(Whisperer.defined_any?).to be_true
      end
    end

    context 'when there are not defined fixture_builders' do
      it 'returns false' do
        expect(Whisperer.defined_any?).to be_false
      end
    end
  end

  describe '.generate' do
    context 'when there is not such fixture builder' do
      it 'raises an error' do
        expect { described_class.generate(:mytest) }.to raise_error(
          Whisperer::NoFixtureBuilderError,
          'There is not fixture builder with "mytest" name.'
        )
      end
    end
  end

  describe '.generate_all' do
    context 'when there are not defined fixture builders' do
      before do
        Whisperer.stub(:defined_any?).and_return(false)
      end

      it 'raises and error' do
        expect { described_class.generate_all }.to raise_error(
          Whisperer::NoFixtureBuilderError,
          'Fixture builders are not found.'
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