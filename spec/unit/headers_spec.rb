require 'spec_helper'

describe Whisperer::Headers do
  describe '.to_hash' do
    subject {
      obj = described_class.new()

      obj.extend(Virtus.model)
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