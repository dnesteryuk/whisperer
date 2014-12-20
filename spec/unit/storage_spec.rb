require 'spec_helper'

describe Whisperer::Storage do
  describe '.define' do
    let(:cassette_record) { instance_double('Whisperer::Record') }
    let(:dsl)             { instance_double('Whisperer::Dsl', container: cassette_record) }

    before do
      allow(Whisperer::Dsl).to receive(:build).and_return(dsl)
    end

    after do
      described_class.reset_storage
    end

    it 'builds the dsl object' do
      expect(Whisperer::Dsl).to receive(:build)

      described_class.define(:test) {}
    end

    it 'executes a given block over the dsl object' do
      expect(dsl).to receive(:request)

      described_class.define(:test) {
        request
      }
    end

    it 'stores the generated cassette record' do
      described_class.define(:test) {}

      expect(described_class.cassette_record(:test)).to eq(cassette_record)
      expect(described_class.defined_any?).to be_truthy
    end

    context 'when a string as a name of the cassette record is given' do
      it 'stores a cassette record with a symbol key' do
        described_class.define('test') {}

        expect(described_class.cassette_record(:test)).to eq(cassette_record)
      end
    end

    context 'when a parent is defined for a cassette record' do
      context 'when such parent exists' do
        let(:orig_cassette_record) { double('original cassette record') }

        before do
          expect(described_class).to receive(:cassette_record).with(:some_parent).and_return(
            orig_cassette_record
          )
        end

        it 'merges the original record with the newly built' do
          expect(Whisperer::Merger).to receive(:merge).with(
            cassette_record,
            orig_cassette_record
          )

          described_class.define('test', parent: :some_parent) {}
        end
      end

      context 'when such parent does not exist' do
        it 'raises an error' do
          expect {
            described_class.define('test', parent: :some_parent) {}
          }.to raise_error(ArgumentError, 'Parent record "some_parent" is not declared.')
        end
      end
    end
  end

  describe '.defined_any?' do
    context 'when there are not defined cassette_records' do
      it 'returns false' do
        expect(described_class.defined_any?).to be_falsey
      end
    end
  end
end