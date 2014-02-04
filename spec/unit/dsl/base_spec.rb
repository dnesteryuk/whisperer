require 'spec_helper'

describe Whisperer::BaseDsl do
  context 'class method' do
    describe '.link_dsl' do
      before :all do
        described_class.link_dsl('header')
      end

      context 'using of the generated method for accessing sub DSL' do
        let(:header_container) { double('header container') }
        let(:body_container)   { double('body container') }

        let(:container) do
          double(
            'container',
            header: header_container,
            body:   body_container
          )
        end

        let(:header) { double('Whisperer::Dsl::Header') }

        subject { described_class.new(container) }

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
    end

    describe '.build' do
      context 'when there is a linked container class' do
        let(:request) { instance_double('Whisperer::Request') }

        before do
          described_class.link_container_class(Whisperer::Request)

          Whisperer::Request.stub(:new).and_return(request)
        end

        it 'initializes a new instance of an object for keeping data' do
          expect(Whisperer::Request).to receive(:new)

          described_class.build
        end

        it 'initializes a new instance of the dsl' do
          expect(described_class).to receive(:new).with(request)

          described_class.build
        end
      end

      context 'when there is not a linked container class' do
        before do
          described_class.instance_variable_set(:@container_class, nil)
        end

        it 'raises an error' do
          expect { described_class.build }.to raise_error(
            ArgumentError,
            'You should associate a container (model) with this dsl class, before building it'
          )
        end
      end
    end
  end
end