require 'spec_helper'

FakeClass = Class.new

describe Whisperer::Helpers do
  describe '.add_builder' do
    let(:obj) { 'some simple object' }

    let(:faker) {
      instance_double('FakeClass', process: true)
    }

    before(:all) do
      FakeClass.extend(Whisperer::Helpers)
      FakeClass.add_builder(:process)
    end

    before do
      FakeClass.stub(:new).and_return(faker)
    end

    subject { FakeClass.process(obj) }

    it 'initializes the fake object' do
      expect(FakeClass).to receive(:new).with(obj)

      subject
    end

    it 'serializes an object' do
      expect(faker).to receive(:process)

      subject
    end
  end
end