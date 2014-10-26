require 'spec_helper'

describe Whisperer::BaseDsl do
  context 'class method' do
    describe '.link_dsl' do
      before :all do
        described_class.link_dsl('headers')
      end

      context 'using of the generated method for accessing sub DSL' do
        let(:headers_container) { double('headers container') }

        let(:container) do
          double(
            'container',
            headers: headers_container
          )
        end

        let(:headers) { double('Whisperer::Dsl::Headers') }

        subject { described_class.new(container) }

        before do
          allow(Whisperer::Dsl::Headers).to receive(:new).and_return(headers)
        end

        it 'initializes the header dsl object' do
          expect(Whisperer::Dsl::Headers).to receive(:new).with(headers_container)

          subject.headers {}
        end

        it 'executes a given block over the header dsl object' do
          expect(headers).to receive(:accept).with('test')

          subject.headers {
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

          allow(Whisperer::Request).to receive(:new).and_return(request)
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

    describe '.add_writer' do
      context 'using of the generated method for writing data to the container' do
        let(:container) { double }

        before :all do
          described_class.add_writer('some_attr')
        end

        subject { described_class.new(container) }

        it 'writes a given value to the container' do
          expect(container).to receive("some_attr=").with('my value')

          subject.some_attr('my value')
        end
      end
    end
  end
end