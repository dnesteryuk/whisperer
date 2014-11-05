require 'spec_helper'

TestUser = Class.new(OpenStruct)

FactoryGirl.define do
  factory :john_snow, class: TestUser do
    name 'John Snow'
  end

  factory :eddard_stark, class: TestUser do
    name 'Eddard Stark'
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
        expect(model.last.name).to eq('Eddard Stark')
      end

      subject.factories([:john_snow, :eddard_stark])
    end
  end

  describe '#raw_data' do
    let(:container) { instance_double('Whisperer::Body', :data_obj= => true, :serializer_opts= => true) }

    it 'assigns the data object to the container' do
      expect(container).to receive(:data_obj=).with('test obj')

      subject.raw_data('test obj')
    end

    it 'assigns the serializer options to the container' do
      expect(container).to receive(:serializer_opts=).with('test options')

      subject.raw_data(nil, 'test options')
    end
  end

  describe '#serializer' do
    let(:container) { instance_double('Whisperer::Body', :serializer= => true) }

    it 'converts the name to the symbol and assigns to the container' do
      expect(container).to receive(:serializer=).with(:test_name)

      subject.serializer 'test_name'
    end
  end
end