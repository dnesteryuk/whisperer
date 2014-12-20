require 'spec_helper'

describe Whisperer do
  describe '.define' do
    it 'proxies to the storage class' do
      expect(Whisperer::Storage).to receive(:define).with(
        'test arg'
      )

      described_class.define('test arg')
    end
  end

  describe '.generate' do
    context 'when the cassette record with the given name does not exist' do
      before do
        expect(Whisperer::Storage).to receive(:cassette_record).and_return(nil)
      end

      it 'raises an error' do
        expect { described_class.generate(:mytest) }.to raise_error(
          Whisperer::NoCassetteRecordError,
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
        expect(Whisperer::Storage).to receive(:cassette_record).with(:test).and_return(cassette_record)
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
      let(:record1) { double('Cassette record 1') }
      let(:record2) { double('Cassette record 2') }

      before do
        expect(Whisperer::Storage).to receive(:cassette_records).and_return(
          record1: record1,
          record2: record2
        )

        allow(Whisperer::Storage).to receive(:defined_any?).and_return(true)
        allow(Whisperer::Generator).to receive(:generate)
      end

      it 'generates the VCR cassette based on record1' do
        expect(Whisperer::Generator).to receive(:generate).with(
          record1,
          :record1
        )

        described_class.generate_all
      end

      it 'generates the VCR cassette based on record2' do
        expect(Whisperer::Generator).to receive(:generate).with(
          record2,
          :record2
        )

        described_class.generate_all
      end
    end

    context 'when there are not defined cassette records' do
      before do
        allow(Whisperer).to receive(:defined_any?).and_return(false)
      end

      it 'raises and error' do
        expect { described_class.generate_all }.to raise_error(
          Whisperer::NoCassetteRecordError,
          'Cassette builders are not found.'
        )
      end
    end
  end

  describe '.register_serializer' do
    it 'registers a serializer' do
      expect(Whisperer::Serializers).to receive(:register).with('some name', 'some class')

      Whisperer.register_serializer('some name', 'some class')
    end
  end

  describe '.register_preprocessor' do
    it 'registers a preprocessor' do
      expect(Whisperer::Preprocessors).to receive(:register).with('some name', 'some class')

      Whisperer.register_preprocessor('some name', 'some class')
    end
  end
end