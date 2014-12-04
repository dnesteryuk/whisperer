require 'whisperer/version'

require 'virtus'
require 'vcr'

require 'whisperer/config'

require 'whisperer/placeholder'
require 'whisperer/dsl'
require 'whisperer/helpers'

require 'whisperer/generator'
require 'whisperer/merger'

require 'whisperer/convertors/hash'
require 'whisperer/convertors/interaction'

require 'whisperer/serializers/json'
require 'whisperer/serializers/json_multiple'

require 'whisperer/preprocessors'
require 'whisperer/preprocessors/default_values'
require 'whisperer/preprocessors/content_length'
require 'whisperer/preprocessors/response_body'

module Whisperer
  @cassette_records = ThreadSafe::Hash.new
  @serializers      = ThreadSafe::Hash.new

  class << self
    attr_reader :cassette_records
    attr_reader :serializers

    def define(name, options = {}, &block)
      dsl = Dsl.build
      dsl.instance_eval &block
      record = dsl.container

      if options[:parent]
        original_record = cassette_records[options[:parent]]

        if original_record.nil?
          raise ArgumentError.new("Parent record \"#{options[:parent]}\" is not declared.")
        else
          Merger.merge(record, original_record)
        end
      end

      cassette_records[name.to_sym] = record
    end

    # Returns true if at least one factory is defined, otherwise returns false.
    def defined_any?
      cassette_records.size > 0
    end

    def generate(name)
      name = name.to_sym

      unless cassette_records[name]
        raise NocassetteRecordError.new("There is not cassette builder with \"#{name}\" name.")
      end

      container = cassette_records[name]

      Generator.generate(container, name)
    end

    def generate_all
      if defined_any?
        cassette_records.each do |name, container|
          generate(name)
        end
      else
        raise NocassetteRecordError.new('cassette builders are not found.')
      end
    end

    def serializer(name)
      unless serializers[name]
        raise ArgumentError.new("There is not serializer registered with \"#{name}\" name")
      end

      serializers[name]
    end

    def register_serializer(name, class_name)
      serializers[name] = class_name
    end

    def register_preprocessor(name, class_name)
      Preprocessors.register(name, class_name)
    end
  end

  class NocassetteRecordError < ArgumentError; end
end


Whisperer.register_serializer(:json, Whisperer::Serializers::Json)
Whisperer.register_serializer(:json_multiple, Whisperer::Serializers::JsonMultiple)

Whisperer.register_preprocessor(:default_values, Whisperer::Preprocessors::DefaultValues)
Whisperer.register_preprocessor(:response_body,  Whisperer::Preprocessors::ResponseBody)
Whisperer.register_preprocessor(:content_length, Whisperer::Preprocessors::ContentLength)