require 'spec_helper'

describe Whisperer::Dsl::Headers do
  let(:container) { Whisperer::Headers.new }

  subject { described_class.new(container) }

  describe '#method_missing' do
    it 'defines the accept attribute' do
      subject.accept('text/plain')

      expect(
        container.respond_to?(:accept)
      ).to be_truthy
    end

    it 'assigns the value to the newly defined accept method' do
      subject.accept('text/plain')

      expect(container.accept).to eq('text/plain')
    end
  end

  describe '#respond_to?' do
    it 'responds to the accept method' do
      subject.accept('text/plain')

      expect(subject.respond_to?(:accept)).to be_truthy
    end
  end
end