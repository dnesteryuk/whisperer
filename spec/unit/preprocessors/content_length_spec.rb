require 'spec_helper'

describe Whisperer::Preprocessors::ContentLength do
  describe '.process' do
    let(:record)    { 'some record' }
    let(:processor) { instance_double('Whisperer::Preprocessors::ContentLength', process: true) }

    before do
      described_class.stub(:new).and_return(processor)
    end

    it 'initializes a new instance of preprocessor' do
      expect(described_class).to receive(:new).with(record)

      described_class.process(record)
    end

    it 'processes a record' do
      expect(processor).to receive(:process)

      described_class.process(record)
    end
  end

  describe '#process' do
    subject { described_class.new(record) }

    context 'when a content length for a response is defined' do
      let(:record) {
        r = Whisperer::Record.new
        r.response.headers.content_length = '10'
        r
      }

      it 'record has a unchanged content length' do
        subject.process

        expect(record.response.headers.content_length).to eq('10')
      end
    end

    context 'when a content length for a response is not defined' do
      let(:record) {
        Whisperer::Record.new(
          response: {
            body: {
              string: 'test'
            }
          }
        )
      }

      it 'measures size of body and writes it to the content length header of the reponse' do
        subject.process

        expect(record.response.headers.content_length).to eq('4')
      end
    end
  end
end