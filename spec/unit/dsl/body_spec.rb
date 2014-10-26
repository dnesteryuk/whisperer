require 'spec_helper'

TestUser = Class.new(OpenStruct)

FactoryGirl.define do
  factory :john_snow, class: TestUser do
    name 'John Snow'
  end

  factory :bran_stark, class: TestUser do
    name 'Bran Stark'
  end
end

describe Whisperer::Dsl::Body do
  let(:serialized_data) { 'serialized data' }
  let(:container)       { instance_double('Whisperer::Body', :string= => true) }
  let(:serializer)      { double('Serialize', serialize: true) }

  subject { described_class.new(container) }

  before do
    allow(Whisperer).to receive(:serializer).and_return(serializer)
    allow(serializer).to receive(:serialize).and_return(serialized_data)
  end

  describe '#factory' do
    it 'writes a factory' do
      expect(subject).to receive(:raw_data) do |model|
        expect(model.name).to eq('John Snow')
      end

      subject.factory(:john_snow)
    end
  end

  describe '#factories' do
    it 'writes factories' do
      expect(subject).to receive(:raw_data) do |model|
        expect(model.first.name).to eq('John Snow')
        expect(model.last.name).to eq('Bran Stark')
      end

      subject.factories([:john_snow, :bran_stark])
    end
  end

  describe '#raw_data' do
    let(:data) { 'some data' }

    it 'gets a serializer' do
      expect(Whisperer).to receive(:serializer).with(:json)

      subject.raw_data(data)
    end

    context 'when options for a serializer is not given' do
      it 'serializes a give data' do
        expect(serializer).to receive(:serialize).with(data, {})

        subject.raw_data(data)
      end
    end

    context 'when options for a serializer is given' do
      it 'serializes a give data' do
        expect(serializer).to receive(:serialize).with(data, 'some options')

        subject.raw_data(data, :json, 'some options')
      end
    end

    it 'assigns the serialized data to the container' do
      expect(container).to receive(:string=).with(serialized_data)

      subject.raw_data(data)
    end
  end
end