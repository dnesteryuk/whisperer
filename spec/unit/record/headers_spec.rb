require 'spec_helper'

describe Whisperer::Headers do
  describe '.new' do
    context 'when there is not such attribute' do
      subject {
        described_class.new(connection: 'keep-alive')
      }

      it 'adds them dynamically' do
        expect(subject.connection).to eq('keep-alive')
      end
    end
  end

  describe '#to_hash' do
    subject {
      obj = described_class.new()

      obj.attribute(:content_type, String)
      obj.attributes = {
        content_type: 'json'
      }
      obj
    }

    it 'returns a hash with correct keys' do
      expect(subject.to_hash).to eq(
        'Content-Type' => 'json'
      )
    end
  end
end