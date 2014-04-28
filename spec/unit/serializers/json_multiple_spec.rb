require 'spec_helper'

describe Whisperer::Serializers::JsonMultiple do
  describe '#serialize' do
    let(:attrs) {
      {
        first_name: 'John',
        last_name:  'Snow'
      }
    }

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