require 'spec_helper'

describe Whisperer::Serializers::Base do
  subject { described_class.new(nil) }

  describe '#serialize' do
    it 'raises an error about implementation' do
      expect{ subject.serialize }.to raise_error(NotImplementedError)
    end
  end
end