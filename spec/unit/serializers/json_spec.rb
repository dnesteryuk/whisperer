require 'spec_helper'

class TestChildJson < Whisperer::Serializers::Json
  protected
    def post_prepare_data(data)
      {test: data}
    end
end

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

    context 'when the class is inherited' do
      subject { TestChildJson.new(OpenStruct.new(attrs)) }

      context 'when the child class alters the data structure' do
        it 'returns the altered structure' do
          expect(subject.serialize).to eq(
            '{"test":{"first_name":"John","last_name":"Snow"}}'
          )
        end
      end
    end
  end
end