require 'spec_helper'

describe Whisperer::Record do
  describe '#project' do
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
        }
      )

      r.request.headers.extend(Virtus.model)
      r.request.headers.attribute(:content_length, Integer)

      r.request.headers.content_length = 100
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

      r.request.headers.extend(Virtus.model)
      r.request.headers.attribute(:content_length, Integer)

      r.request.headers.content_length = 50
      r
    }

    subject { another_record }

    before do
      subject.merge!(record)
    end

    it 'has a content length for the request' do
      expect(subject.request.headers.content_length).to eq(50)
    end

    it 'has ta correct url' do
      expect(subject.request.uri).to eq('http://google.com')
    end

    it 'has a correct encoding for the body of the response' do
      expect(subject.response.body.encoding).to eq('UTF-16')
    end

    it 'has a correct string for the body of the response' do
      expect(subject.response.body.string).to eq('test')
    end
  end
end