require 'spec_helper'

describe Whisperer::Serializers::Json do
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
    describe '#serialize' do
      let(:attrs) {
        {
          first_name: 'John',
          last_name:  'Snow'
        }
      }

      context 'when a simple object is given' do
        subject { described_class.new(OpenStruct.new(attrs)) }

        it 'returns json string with serialized attributes' do
          expect(subject.serialize).to eq('{"first_name":"John","last_name":"Snow"}')
        end
      end

      context 'when an array is given' do
        let(:data) {
          [
            OpenStruct.new(attrs)
          ]
        }

        subject { described_class.new(data) }

        it 'returns json string with a serialized array' do
          expect(subject.serialize).to eq('[{"first_name":"John","last_name":"Snow"}]')
        end
      end
    end
  end
end