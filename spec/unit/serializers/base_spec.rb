require 'spec_helper'

describe Whisperer::Serializers::Base do
  context 'class methods' do
    describe '.serialize' do
      let(:obj) { 'some simple object' }

      let(:serializer) {
        instance_double('Whisperer::Serializers::Json', serialize: true)
      }

      before do
        described_class.stub(:new).and_return(serializer)
      end

      it 'initializes the serializer' do
        expect(described_class).to receive(:new)

        described_class.serialize(obj)
      end

      it 'serializes an object' do
        expect(serializer).to receive(:serialize)

        described_class.serialize(obj)
      end
    end
  end

  context 'instance methods' do
    subject { described_class.new(nil) }

    describe '#serialize' do
      it 'raises an error about implementation' do
        expect{ subject.serialize }.to raise_error(NotImplementedError)
      end
    end
  end
end