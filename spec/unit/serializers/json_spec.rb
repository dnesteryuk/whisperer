require 'spec_helper'

describe Whisperer::Serializers::Json do
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