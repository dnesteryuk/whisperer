require 'yaml'

module Whisperer
  # This config class is used only for Rake tasks.
  # The puspose of it is to allow third users to defile options in Yaml file
  # for generating fixtures and then it will be picked up
  # while generating fixtures.
  class Config
    include Virtus.model

    attribute :path_to_builders,  String, default: 'spec/fixture_builders'

    attribute :generate_to,       String, default: 'spec/fixtures'
    attribute :factories_matcher, String, default: './spec/factories/**/*.rb'
    attribute :builders_matcher,  String, default: -> (c, attr) { "./#{c.path_to_builders}/**/*.rb" }

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

    # Returns yaml record with configuration options.
    def to_yml
      "generate_to:       '#{generate_to}'\n" <<
      "builders_matcher:  '#{builders_matcher}'\n" <<
      "factories_matcher: '#{factories_matcher}'"
    end
  end # class Config
end # module Whisperer