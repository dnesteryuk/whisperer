require 'spec_helper'

describe Whisperer::Config do
  let(:options) {
    {
      generate_to:       'some dir',
      builders_matcher:  'some builder matcher',
      factories_matcher: 'some factories matcher'
    }
  }

  subject { described_class.new(options) }

  describe '#to_yml' do
    it 'returns yml record with the configuration options' do
      expect(subject.to_yml).to eq(
        "generate_to:       '#{options[:generate_to]}'\n" <<
        "builders_matcher:  '#{options[:builders_matcher]}'\n" <<
        "factories_matcher: '#{options[:factories_matcher]}'"
      )
    end
  end
end