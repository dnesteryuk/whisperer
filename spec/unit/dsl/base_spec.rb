require 'spec_helper'

describe Whisperer::Dsl::Base do
  let(:header_container) { double('header container') }
  let(:body_container)   { double('body container') }

  let(:container) do
    double(
      'container',
      header: header_container,
      body:   body_container
    )
  end

  subject { described_class.new(container) }

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
end