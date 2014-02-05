require 'spec_helper'

describe Whisperer do
  describe '.define' do
    let(:dsl) { instance_double('Whisperer::Dsl', container: 'some test') }

    before do
      Whisperer::Dsl.stub(:build).and_return(dsl)
    end

    it 'builds the dsl object' do
      expect(Whisperer::Dsl).to receive(:build)

      described_class.define(:test) {}
    end

    it 'executes a given block over the dsl object' do
      expect(dsl).to receive(:header)

      described_class.define(:test) {
        header
      }
    end
  end
end