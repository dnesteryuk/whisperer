require 'spec_helper'

class TestChildJson < Whisperer::Serializers::Json
  protected
    def post_prepare_data(data)
      {test: data}
    end
end

class TestObj
  attr_accessor :first_name, :last_name

  def initialize(attrs)
    @first_name, @last_name = attrs[:first_name], attrs[:last_name]
  end
end

describe Whisperer::Serializers::Json do
  describe '#serialize' do
    shared_examples 'serializes an object' do
      it 'returns json string with serialized attributes' do
        expect(subject.serialize).to eq('{"first_name":"John","last_name":"Snow"}')
      end

      context 'when the class is inherited' do
        subject { TestChildJson.new(given_obj) }

        context 'when the child class alters the data structure' do
          it 'returns the altered structure' do
            expect(subject.serialize).to eq(
              '{"test":{"first_name":"John","last_name":"Snow"}}'
            )
          end
        end
      end
    end

    let(:attrs) {
      {
        first_name: 'John',
        last_name:  'Snow'
      }
    }

    subject { described_class.new(given_obj) }

    context 'when an open struct object is given' do
      let(:given_obj) {
        OpenStruct.new(attrs)
      }

      it_behaves_like 'serializes an object'
    end

    context 'when PRO is given' do
      let(:given_obj) {
        TestObj.new(attrs)
      }

      it_behaves_like 'serializes an object'
    end
  end
end