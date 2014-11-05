require 'spec_helper'

describe Whisperer::Preprocessors::ResponseBody do
  describe '#process' do
    subject { described_class.new(record) }

    context 'when there is not data object' do
      let(:record) { Whisperer::Record.new }

      it 'does not serialize anything' do
        expect(Whisperer).to_not receive(:serializer)

        subject.process
      end
    end

    context 'when there is data object' do
      let(:serialized_data) { 'serialized data' }
      let(:serializer)      { double('Serializer', serialize: true) }

      let(:data_obj) { OpenStruct.new(test: 'obj') }

      let(:record) {
        r = Whisperer::Record.new
        r.response.body.data_obj   = data_obj
        r.response.body.serializer = :json
        r.response.body.serializer_opts = {some: 'options'}
        r
      }

      before do
        allow(Whisperer).to receive(:serializer).and_return(serializer)
        allow(serializer).to receive(:serialize).and_return(serialized_data)
      end

      it 'gets the serializer' do
        expect(Whisperer).to receive(:serializer).with(:json)

        subject.process
      end

      it 'serializes the respose body' do
        expect(serializer).to receive(:serialize).with(data_obj, {some: 'options'})

        subject.process
      end

      it 'assigns the serialized data to the record' do
        subject.process

        expect(record.response.body.string).to eq(serialized_data)
      end
    end
  end
end