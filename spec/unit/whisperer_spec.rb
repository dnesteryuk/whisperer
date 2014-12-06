require 'spec_helper'

describe Whisperer do
  after do
    described_class.cassette_records.clear
  end

  describe '.define' do
    let(:cassette_record) { instance_double('Whisperer::Record') }
    let(:dsl)             { instance_double('Whisperer::Dsl', container: cassette_record) }

    before do
      allow(Whisperer::Dsl).to receive(:build).and_return(dsl)
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

      expect(Whisperer.cassette_records[:test]).to eq(cassette_record)
    end

    context 'when a string as a name of the cassette record is given' do
      it 'stores a cassette record with a symbol key' do
        described_class.define('test') {}

        expect(Whisperer.cassette_records[:test]).to eq(cassette_record)
      end
    end

    context 'when a parent is defined for a cassette record' do
      context 'when such parent exists' do
        let(:orig_cassette_record) { double('original cassette record') }

        before do
          Whisperer.cassette_records[:some_parent] = orig_cassette_record
        end

        it 'merges the original record with the newly built' do
          expect(Whisperer::Merger).to receive(:merge).with(cassette_record, orig_cassette_record)

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
    context 'when there are defined cassette records' do
      before do
        described_class.cassette_records[:test] = true
      end

      it 'returns true' do
        expect(Whisperer.defined_any?).to be_truthy
      end
    end

    context 'when there are not defined cassette_records' do
      it 'returns false' do
        expect(Whisperer.defined_any?).to be_falsey
      end
    end
  end

  describe '.generate' do
    context 'when the cassette record with the given name does not exist' do
      it 'raises an error' do
        expect { described_class.generate(:mytest) }.to raise_error(
          Whisperer::NocassetteRecordError,
          'There is not cassette builder with "mytest" name.'
        )
      end
    end

    context 'when the cassette with the given name exists' do
      shared_examples 'generator' do |name|
        it 'generates the VCR cassette' do
          expect(Whisperer::Generator).to receive(:generate).with(
            cassette_record,
            :test
          )

          described_class.generate(name)
        end
      end

      let(:cassette_record) { double }

      before do
        described_class.cassette_records[:test] = cassette_record
      end

      context 'when the given name is a symbol' do
        it_behaves_like 'generator', :test
      end

      context 'when the given name is a string' do
        it_behaves_like 'generator', 'test'
      end
    end
  end

  describe '.generate_all' do
    context 'when there are defined cassettes' do
      let(:record1) { double('cassette record 1') }
      let(:record2) { double('cassette record 2') }

      before do
        Whisperer::cassette_records[:record1] = record1
        Whisperer::cassette_records[:record2] = record2

        allow(Whisperer).to receive(:defined_any?).and_return(true)
        allow(Whisperer).to receive(:generate)
      end

      it 'generates the VCR cassette based on record1' do
        expect(Whisperer).to receive(:generate).with(:record1)

        described_class.generate_all
      end

      it 'generates the VCR cassette based on record2' do
        expect(Whisperer).to receive(:generate).with(:record2)

        described_class.generate_all
      end
    end

    context 'when there are not defined cassette records' do
      before do
        allow(Whisperer).to receive(:defined_any?).and_return(false)
      end

      it 'raises and error' do
        expect { described_class.generate_all }.to raise_error(
          Whisperer::NocassetteRecordError,
          'cassette builders are not found.'
        )
      end
    end
  end

  describe '.register_serializer' do
    it 'registers serializer' do
      expect(Whisperer::Serializers).to receive(:register).with('some name', 'some class')

      Whisperer.register_serializer('some name', 'some class')
    end
  end

  describe '.register_preprocessor' do
    it 'registers preprocessor' do
      expect(Whisperer::Preprocessors).to receive(:register).with('some name', 'some class')

      Whisperer.register_preprocessor('some name', 'some class')
    end
  end
end