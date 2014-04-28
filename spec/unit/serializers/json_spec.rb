require 'spec_helper'

describe Whisperer::Serializers::Json do
  describe '#serialize' do
    let(:attrs) {
      {
        first_name: 'John',
        last_name:  'Snow'
      }
    }

    subject { described_class.new(OpenStruct.new(attrs)) }

    it 'returns json string with serialized attributes' do
      expect(subject.serialize).to eq('{"first_name":"John","last_name":"Snow"}')
    end
  end
end