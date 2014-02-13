require 'spec_helper'

TestUser = Class.new(OpenStruct)

FactoryGirl.define do
  factory :test_user do
    name 'John Snow'
  end
end

describe Whisperer::Dsl::Body do
  let(:container) { instance_double('Whisperer::Body', :string= => true) }

  describe '#factory' do
    let(:serialized_data) { 'serialized data' }

    subject { described_class.new(container) }

    before do
      Whisperer::Serializers::Json.stub(:serialize).and_return(serialized_data)
    end

    it 'takes factory and serializes it' do
      expect(Whisperer::Serializers::Json).to receive(:serialize) do |model|
        expect(model.name).to eq('John Snow')
      end

      subject.factory(:test_user, :json)
    end

    it 'assigns the serialized data to the container' do
      expect(container).to receive(:string=).with(serialized_data)

      subject.factory(:test_user, :json)
    end
  end
end