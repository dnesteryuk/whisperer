require 'spec_helper'

describe Whisperer::Preprocessors::DefaultValues do
  describe '#process' do
    let(:record) {
      r = Whisperer::Record.new
      r.request.method       = Whisperer::DefaultValue.new(:get)
      r.response.status.code = Whisperer::DefaultValue.new(200)
      r
    }

    subject { described_class.new(record) }

    before do
      subject.process
    end

    it 'has correct value for the request method' do
      expect(record.request.method).to eq(:get)
    end

    it 'has correct value for the response status' do
      expect(record.response.status.code).to eq(200)
    end
  end
end
