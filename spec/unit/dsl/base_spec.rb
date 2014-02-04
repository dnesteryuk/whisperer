require 'spec_helper'

describe Whisperer::Dsl::Base do
  context 'class method' do
    describe '#link_dsl' do
      before :all do
        Whisperer::Dsl::Base.link_dsl('header')
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
  end
end