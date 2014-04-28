module Whisperer
  # This config class is used only for Rake tasks.
  # The puspose of it is to allow third users to defile options in Yaml file
  # for generating fixtures and then it will be picked up
  # while generating fixtures.
  class Config
    include Virtus.model

    attribute :generate_to,       String, default: 'spec/fixtures'
    attribute :factories_matcher, String, default: './spec/factories/**/*.rb'
    attribute :builders_matcher,  String, default: './spec/fixture_builders/**/*.rb'

    def self.load(file_name = nil)
      raw_config = {}

      if file_name && File.exists?(file_name)
        raw_config = YAML.load(File.read(file_name)) || {}
      end

      config = new(raw_config)

      VCR.configure do |c|
        c.cassette_library_dir = config.generate_to
      end

      config
    end
  end # class Config
end # module Whisperer