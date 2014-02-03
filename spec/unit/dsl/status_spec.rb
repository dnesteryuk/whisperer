require 'spec_helper'

describe Whisperer::Dsl::Status do
  let(:container) do
    instance_double('Whisperer::Status')
  end

  subject { described_class.new(container) }

  before do
    container.extend(Virtus.model)
  end

  describe '#message' do
    it 'assigns message' do
      expect(container).to receive(:message=).with('OK')

      subject.message('OK')
    end
  end

  describe '#code' do
    it 'assigns code' do
      expect(container).to receive(:code=).with(200)

      subject.code(200)
    end
  end
end