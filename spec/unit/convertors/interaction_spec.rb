require 'spec_helper'

describe Whisperer::Convertors::Interaction do
  describe '#convert' do
    let(:obj) { double }

    let(:hash) {
      {
        'request' => {
          'uri'    => 'http://google.com',
          'method' => :get
        },
        'response' => {
          'body' => 'test body'
        },
        'recorded_at' => Time.now.httpdate
      }
    }

    subject { described_class.new(obj).convert }

    before do
      allow(Whisperer::Convertors::Hash).to receive(:convert).and_return(hash)
    end

    it 'converts the given record to hash' do
      expect(Whisperer::Convertors::Hash).to receive(:convert).with(obj).and_return(hash)

      subject
    end

    context 'returns the VCR interraction object' do
      it 'has a proper url' do
        expect(subject.request.uri).to eq(hash['request']['uri'])
      end

      it 'has a proper HTTP method' do
        expect(subject.request.method).to eq(hash['request']['method'])
      end

      it 'has a proper response body' do
        expect(subject.response.body).to eq(hash['response']['body'])
      end
    end
  end
end