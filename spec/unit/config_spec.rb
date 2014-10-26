require 'spec_helper'

describe Whisperer::Config do
  describe '.load' do
    shared_examples 'initializes the config' do |parsed_yml|
      it 'initializes the config object' do
        expect(Whisperer::Config).to receive(:new).with(parsed_yml).and_return(config)

        subject
      end

      it 'VCR has a define path to cassettes' do
        subject

        expect(VCR.configuration.cassette_library_dir).to eq(dirname)
      end

      it 'returns the configuration object' do
        res = subject

        expect(res).to eq(config)
      end
    end

    let(:dirname) { '/tmp' }
    let(:config)  { instance_double(Whisperer::Config, generate_to: dirname) }

    subject { described_class }

    before do
      allow(Whisperer::Config).to receive(:new).and_return(config)
    end

    context 'when the configuration name is passed' do
      context 'when the configuration file exists' do
        subject { described_class.load('/tmp/whisperer.test') }

        after do
          File.delete('/tmp/whisperer.test')
        end

        context 'when it is not empty' do
          before do
            f = File.new('/tmp/whisperer.test', 'w')
            f.write('test: 1')
            f.close
          end

          it_behaves_like 'initializes the config', {"test" => 1}
        end

        context 'when it is empty' do
          before do
            File.new('/tmp/whisperer.test', 'w').close
          end

          it_behaves_like 'initializes the config', {}
        end
      end

      context 'when the configuration file does not exist' do
        subject { described_class.load('/tmp/doesnotexist') }

        it_behaves_like 'initializes the config', {}
      end
    end

    context 'when the configuration name is not passed' do
      subject { described_class.load }

      it_behaves_like 'initializes the config', {}
    end
  end

  describe '#to_yml' do
    let(:options) {
      {
        generate_to:       'some dir',
        builders_matcher:  'some builder matcher',
        factories_matcher: 'some factories matcher'
      }
    }

    subject { described_class.new(options) }

    it 'returns yml record with the configuration options' do
      expect(subject.to_yml).to eq(
        "generate_to:       '#{options[:generate_to]}'\n" <<
        "builders_matcher:  '#{options[:builders_matcher]}'\n" <<
        "factories_matcher: '#{options[:factories_matcher]}'"
      )
    end
  end
end