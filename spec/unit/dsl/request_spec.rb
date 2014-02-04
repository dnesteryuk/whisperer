require 'spec_helper'

describe Whisperer::Dsl::Request do
  let(:container) do
    instance_double('Whisperer::Request')
  end

  subject { described_class.new(container) }

  describe '#uri' do
    it 'assigns uri' do
      expect(container).to receive(:uri=).with('http://google.com')

      subject.uri('http://google.com')
    end
  end

  describe '#method' do
    it 'assigns method' do
      expect(container).to receive(:method=).with('get')

      subject.method('get')
    end
  end
end