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
    let(:header_container) { double('header container') }

    let(:container) do
      instance_double(
        'Whisperer::Request',
        header: header_container
      )
    end

    subject { described_class.new(container) }

    describe '#uri' do
      it 'assigns uri' do
        expect(container).to receive(:uri=).with('http://google.com')

        subject.uri('http://google.com')
      end
    end

    describe '#header' do
      let(:header) { double('Whisperer::Header') }

      before do
        Whisperer::Dsl::Header.stub(:new).and_return(header)
      end

      it 'initializes the header dsl object' do
        expect(Whisperer::Dsl::Header).to receive(:new).with(header_container)

        subject.header {}
      end

      it 'executes a given block over header object' do
        expect(header).to receive(:accept).with('test')

        subject.header {
          accept 'test'
        }
      end
    end

    describe '#body' do
    end

    describe '#method' do
      it 'assigns method' do
        expect(container).to receive(:method=).with('get')

        subject.method('get')
      end
    end
  end
end