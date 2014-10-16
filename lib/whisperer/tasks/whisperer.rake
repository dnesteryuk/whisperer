require 'whisperer'
require 'whisperer/config'

require 'active_support/core_ext/hash/deep_merge'
require 'factory_girl'
require 'rainbow'
require 'yaml'

config = Whisperer::Config.load('.whisperer.yml')

Dir[
  config.factories_matcher,
  config.builders_matcher
].each {|f| require f }

namespace :whisperer do
  desc 'Takes all fixture builders and generates fixtures for VCR'
  task :generate_all do
    begin
      Whisperer.generate_all

      puts Rainbow('Fixtures are generated').green
    rescue Whisperer::NoFixtureRecordError => error
      puts Rainbow("Any fixture builder was found. Please, make sure you define at least one (We are looking for it like: #{config.builders_matcher}).").yellow
    end
  end

  desc 'Takes a specific fixture builder and generates one specific fixture for VCR'
  task :generate, :name do |t, args|
    name = args[:name]

    begin
      Whisperer::generate(name)

      puts Rainbow("The fixture '#{name}' is generated").green
    rescue Whisperer::NoFixtureRecordError => error
      puts Rainbow(error.message).red
    end
  end

  desc 'Creates minimal structure of directories, creates a config file with default options'
  task install: [:create_config] do
    path_to_builders = 'spec/fixture_builders'

    if Dir.exists?(path_to_builders)
      puts Rainbow("Skipped creating of #{path_to_builders} since it already exists").green
    else
      Dir.mkdir(path_to_builders)

      puts Rainbow("Created directory for fixture builders: #{path_to_builders}").green
    end

    #Rake::Task[:create_config].invoke
  end

  desc 'Creates a config file with default options'
  task :create_config do
    if File.exists?('.whisperer.yml')
      puts Rainbow("Skipped creating the sample of config (.whisperer.yml) since it already exists").green
    else
      File.open(
        '.whisperer.yml',
        File::CREAT|File::RDWR,
        0644
      ) do |f|
        f.write(
          "generate_to:       '#{config.generate_to}'\n" <<
          "builders_matcher:  '#{config.builders_matcher}'\n" <<
          "factories_matcher: '#{config.factories_matcher}'"
        )

        f.close
      end

      puts Rainbow("Created the sample of config: .whisperer.yml").green
    end
  end
end