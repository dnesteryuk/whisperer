require 'spec_helper'

TestUser = Class.new(OpenStruct)

FactoryGirl.define do
  factory :john_snow, class: TestUser do
    name 'John Snow'
  end

  factory :arya_stark, class: TestUser do
    name 'Arya Stark'
  end
end

describe Whisperer::Dsl::Body do
  let(:serialized_data) { 'serialized data' }
  let(:container)       { instance_double('Whisperer::Body', :string= => true) }
  let(:serializer)      { double('Serialize', serialize: true) }

  subject { described_class.new(container) }

  before do
    Whisperer.stub(:serializer).and_return(serializer)
    serializer.stub(:serialize).and_return(serialized_data)
  end

  describe '#factory' do
    it 'gets a serializer' do
      expect(Whisperer).to receive(:serializer).with(:json)

      subject.factory(:john_snow, :json)
    end

    it 'takes factory and serializes it' do
      expect(serializer).to receive(:serialize) do |model|
        expect(model.name).to eq('John Snow')
      end

      subject.factory(:john_snow, :json)
    end

    it 'assigns the serialized data to the container' do
      expect(container).to receive(:string=).with(serialized_data)

      subject.factory(:john_snow, :json)
    end
  end

  describe '#factories' do
    it 'gets a serializer' do
      expect(Whisperer).to receive(:serializer).with(:json)

      subject.factory(:john_snow, :json)
    end

    it 'takes factories and serializes it' do
      expect(serializer).to receive(:serialize) do |data|
        expect(data.first.name).to eq('John Snow')
        expect(data.last.name).to eq('Arya Stark')
      end

      subject.factories([:john_snow, :arya_stark], :json)
    end

    it 'assigns the serialized data to the container' do
      expect(container).to receive(:string=).with(serialized_data)

      subject.factories([:john_snow, :arya_stark], :json)
    end
  end
end