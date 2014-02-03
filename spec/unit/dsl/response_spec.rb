require 'spec_helper'

describe Whisperer::Dsl::Response do
  let(:status_container) { instance_double('Whisperer::Status') }

  let(:container) do
    double(
      'container',
      status: status_container
    )
  end

  subject { described_class.new(container) }

  describe '#status' do
    let(:status) { double('Whisperer::Dsl::Status') }

    before do
      Whisperer::Dsl::Status.stub(:new).and_return(status)
    end

    it 'initializes the status dsl object' do
      expect(Whisperer::Dsl::Status).to receive(:new).with(status_container)

      subject.status {}
    end

    it 'executes a given block over the status dsl object' do
      expect(status).to receive(:message).with('test')

      subject.status {
        message 'test'
      }
    end
  end
end