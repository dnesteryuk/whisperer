require 'spec_helper'

describe Whisperer::Merger do
  describe '#merge' do
    let(:default_parent) {
      r = Whisperer::Record.new(
        request: {
          uri: 'http://google.com',
        },
        response: {
          body: {
            encoding: 'UTF-8',
            string:   'test'
          }
        },
        recorded_at: 'test data'
      )

      r.request.headers.attribute(:content_length, Integer)
      r.request.headers.attribute(:accept, String)

      r.request.headers.content_length = 100
      r.request.headers.accept         = 'javascript'

      r.response.body.serializer = :test_serializer
      r
    }

    let(:default_child) {
      r = Whisperer::Record.new(
        request: {
          headers: {
            content_length: 50
          }
        },
        response: {
          body: {
            encoding: 'UTF-16'
          }
        }
      )

      r.request.headers.attribute(:content_length, Integer)

      r.request.headers.content_length = 50
      r
    }

    let(:parent) { default_parent }
    let(:child)  { default_child }

    subject { Whisperer::Merger.new(child, parent) }

    before do
      subject.merge
    end

    it 'has a correct content length header for the request' do
      expect(child.request.headers.content_length).to eq(50)
    end

    it 'has an accept header for the request' do
      expect(child.request.headers.accept).to eq('javascript')
    end

    it 'has an url' do
      expect(child.request.uri).to eq('http://google.com')
    end

    it 'has a correct encoding for the body of the response' do
      expect(child.response.body.encoding).to eq('UTF-16')
    end

    it 'has a string for the body of the response' do
      expect(child.response.body.string).to eq('test')
    end

    it 'has a correct serializer for the body of the response' do
      expect(child.response.body.serializer).to eq(:test_serializer)
    end

    it 'has a correct recorded_at value' do
      expect(child.recorded_at).to eq('test data')
    end

    context 'when the default value for the serializer is used again' do
      let(:child) {
        r = default_child
        r.response.body.serializer = :json
        r
      }

      it 'has the newly defined value' do
        skip 'this bug is not fixed yet'
        expect(child.response.body.serializer).to eq(:json)
      end
    end
  end
end