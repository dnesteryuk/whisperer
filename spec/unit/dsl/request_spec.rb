require 'spec_helper'

describe Whisperer::Dsl::Request do
  describe '.build' do
    let(:request) { instance_double('Whisperer::Request') }

    before do
      Whisperer::Request.stub(:new).and_return(request)
    end

    it 'initializes a new instance of an object for keeping data about a request' do
      expect(Whisperer::Request).to receive(:new)

      described_class.build
    end

    it 'initializes a new instance of the request dsl' do
      expect(described_class).to receive(:new).with(request)

      described_class.build
    end
  end

  context 'instance methods' do
    let(:container) do
      instance_double('Whisperer::Request')
    end

    subject { described_class.new(container) }

    describe '#uri' do
      it 'assigns uri' do
        expect(container).to receive(:uri=).with('http://google.com')

        subject.uri('http://google.com')
      end
    end

    describe '#method' do
      it 'assigns method' do
        expect(container).to receive(:method=).with('get')

        subject.method('get')
      end
    end
  end
end