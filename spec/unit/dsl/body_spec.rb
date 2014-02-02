require 'spec_helper'

describe Whisperer::Dsl::Body do
  let(:container) { instance_double('Whisperer::Body') }

  subject { described_class.new(container) }

  describe '#encoding' do
    it 'assigns encoding' do
      expect(container).to receive(:encoding=).with('UTF8')

      subject.encoding('UTF8')
    end
  end

  describe '#string' do
    it 'assigns string' do
      expect(container).to receive(:string=).with('{}')

      subject.string('{}')
    end
  end
end