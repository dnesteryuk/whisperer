require 'spec_helper'

describe Whisperer do
  after do
    described_class.fixture_records.clear
  end

  describe '.define' do
    let(:fixture_record) { instance_double('Whisperer::Record', merge!: true) }
    let(:dsl)            { instance_double('Whisperer::Dsl', container: fixture_record) }

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

    it 'stores the generated fixture record' do
      described_class.define(:test) {}

      expect(Whisperer.fixture_records[:test]).to eq(fixture_record)
    end

    context 'when a string as a name of a fixture record is given' do
      it 'stores a fixture record with a symbol key' do
        described_class.define('test') {}

        expect(Whisperer.fixture_records[:test]).to eq(fixture_record)
      end
    end

    context 'when a parent is defined for a fixture record' do
      context 'when such parent exists' do
        let(:original_fixture_record) { double('original fixture record') }

        before do
          Whisperer.fixture_records[:some_parent] = original_fixture_record
        end

        it 'merges an original record with the newly built' do
          expect(fixture_record).to receive(:merge!).with(original_fixture_record)

          described_class.define('test', parent: :some_parent) {}
        end
      end

      context 'when such parent does not exist' do
        it 'raises an error' do
          expect {
            described_class.define('test', parent: :some_parent) {}
          }.to raise_error(ArgumentError, 'Parent record "some_parent" is not declired.')
        end
      end
    end
  end

  describe '.defined_any?' do
    context 'when there are defined fixture records' do
      before do
        described_class.fixture_records[:test] = true
      end

      it 'returns true' do
        expect(Whisperer.defined_any?).to be_true
      end
    end

    context 'when there are not defined fixture_records' do
      it 'returns false' do
        expect(Whisperer.defined_any?).to be_false
      end
    end
  end

  describe '.generate' do
    context 'when there is not such fixture record' do
      it 'raises an error' do
        expect { described_class.generate(:mytest) }.to raise_error(
          Whisperer::NoFixtureRecordError,
          'There is not fixture builder with "mytest" name.'
        )
      end
    end
  end

  describe '.generate_all' do
    context 'when there are not defined fixture records' do
      before do
        Whisperer.stub(:defined_any?).and_return(false)
      end

      it 'raises and error' do
        expect { described_class.generate_all }.to raise_error(
          Whisperer::NoFixtureRecordError,
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