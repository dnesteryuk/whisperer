require 'spec_helper'

describe Whisperer::Serializers::Base do
  let(:options) { {test: 1} }

  subject { described_class.new(nil, options: options) }

  describe '.new' do
    it 'keeps given options' do
      expect(subject.options).to eq(options)
    end
  end

  describe '#serialize' do
    it 'raises an error about implementation' do
      expect{ subject.serialize }.to raise_error(NotImplementedError)
    end
  end
end