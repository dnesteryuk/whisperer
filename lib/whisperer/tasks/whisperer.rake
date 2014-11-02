require 'whisperer'

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
  desc 'Creates minimal structure of directories, creates a config file with default options'
  task install: ['config:create'] do
    path_to_builders = 'spec/cassette_builders'

    if Dir.exists?(path_to_builders)
      puts Rainbow("Skipped creating of #{path_to_builders} since it already exists").green
    else
      Dir.mkdir(path_to_builders)

      puts Rainbow("Created directory for cassette builders: #{path_to_builders}").green
    end
  end

  namespace :config do
    desc 'Creates a config file with default options'
    task :create do
      if File.exists?('.whisperer.yml')
        puts Rainbow("Skipped creating the sample of config (.whisperer.yml) since it already exists").green
      else
        File.open(
          '.whisperer.yml',
          File::CREAT|File::RDWR,
          0644
        ) do |f|
          f.write(config.to_yml)

          f.close
        end

        puts Rainbow("Created the sample of config: .whisperer.yml").green
      end
    end
  end

  namespace :cassettes do
    desc 'Takes all cassette builders and generates cassettes for VCR'
    task :generate_all do
      begin
        Whisperer.generate_all

        puts Rainbow('cassettes are generated').green
      rescue Whisperer::NocassetteRecordError => error
        puts Rainbow("Any cassette builder was found. Please, make sure you define at least one (We are looking for it like: #{config.builders_matcher}).").yellow
      end
    end

    desc 'Takes a specific cassette builder and generates one specific cassette for VCR'
    task :generate, :name do |t, args|
      name = args[:name]

      begin
        Whisperer::generate(name)

        puts Rainbow("The cassette '#{name}' is generated").green
      rescue Whisperer::NocassetteRecordError => error
        puts Rainbow(error.message).red
      end
    end

    namespace :builders do
      desc 'Creates a sample of the cassette builder'
      task :sample do
        sample = File.join(File.dirname(__FILE__), '../samples/cassette_builder.rb')

        path_to_save = config.path_to_builders + '/sample.rb'

        FileUtils.cp(sample, path_to_save)

        puts Rainbow("Created the sample of the cassette builder: #{path_to_save}").green
      end
    end
  end
end