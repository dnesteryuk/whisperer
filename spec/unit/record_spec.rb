require 'spec_helper'

describe Whisperer::Record do
  describe '#merge!' do
    let(:record)         {
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
      r
    }

    let(:another_record) {
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

    subject { another_record }

    before do
      subject.merge!(record)
    end

    it 'has a correct content length header for the request' do
      expect(subject.request.headers.content_length).to eq(50)
    end

    it 'has an accept header for the request' do
      expect(subject.request.headers.accept).to eq('javascript')
    end

    it 'has an url' do
      expect(subject.request.uri).to eq('http://google.com')
    end

    it 'has a correct encoding for the body of the response' do
      expect(subject.response.body.encoding).to eq('UTF-16')
    end

    it 'has a string for the body of the response' do
      expect(subject.response.body.string).to eq('test')
    end

    it 'has a correct recorded_at value' do
      expect(subject.recorded_at).to eq('test data')
    end
  end
end