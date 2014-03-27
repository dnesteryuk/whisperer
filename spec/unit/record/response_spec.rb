require 'spec_helper'

describe Whisperer::Response do
  describe '.headers' do
    subject { described_class.new }

    it 'has a content length field' do
      expect(subject.headers).to respond_to(:content_length)
    end
  end
end