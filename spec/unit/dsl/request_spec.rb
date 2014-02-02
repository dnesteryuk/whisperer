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
    let(:body_container)   { double('body container') }

    let(:container) do
      instance_double(
        'Whisperer::Request',
        header: header_container,
        body:   body_container
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
      let(:header) { double('Whisperer::Dsl::Header') }

      before do
        Whisperer::Dsl::Header.stub(:new).and_return(header)
      end

      it 'initializes the header dsl object' do
        expect(Whisperer::Dsl::Header).to receive(:new).with(header_container)

        subject.header {}
      end

      it 'executes a given block over the header dsl object' do
        expect(header).to receive(:accept).with('test')

        subject.header {
          accept 'test'
        }
      end
    end

    describe '#body' do
      let(:body) { instance_double('Whisperer::Dsl::Body') }

      before do
        Whisperer::Dsl::Body.stub(:new).and_return(body)
      end

      it 'initializes the body dsl object' do
        expect(Whisperer::Dsl::Body).to receive(:new).with(body_container)

        subject.body {}
      end

      it 'executes a given block over the body dsl object' do
        expect(body).to receive(:encoding).with('UTF8')

        subject.body {
          encoding 'UTF8'
        }
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