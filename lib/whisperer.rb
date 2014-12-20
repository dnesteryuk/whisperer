require 'whisperer/version'

require 'virtus'
require 'vcr'

require 'whisperer/config'

require 'whisperer/placeholder'
require 'whisperer/dsl'
require 'whisperer/helpers'

require 'whisperer/storage'
require 'whisperer/generator'
require 'whisperer/merger'

require 'whisperer/convertors/hash'
require 'whisperer/convertors/interaction'

require 'whisperer/serializers'
require 'whisperer/serializers/json'
require 'whisperer/serializers/json_multiple'

require 'whisperer/preprocessors'
require 'whisperer/preprocessors/default_values'
require 'whisperer/preprocessors/content_length'
require 'whisperer/preprocessors/response_body'

module Whisperer
  class << self
    def define(*args, &block)
      Storage.define(*args, &block)
    end

    def generate(name)
      name = name.to_sym

      unless container = Storage.cassette_record(name)
        raise NoCassetteRecordError.new("There is not cassette builder with \"#{name}\" name.")
      end

      Generator.generate(container, name)
    end

    def generate_all
      if Storage.defined_any?
        Storage.cassette_records.each do |name, container|
          Generator.generate(container, name)
        end
      else
        raise NoCassetteRecordError.new('Cassette builders are not found.')
      end
    end

    def register_serializer(name, class_name)
      Serializers.register(name, class_name)
    end

    def register_preprocessor(name, class_name)
      Preprocessors.register(name, class_name)
    end
  end

  class NoCassetteRecordError < ArgumentError; end
end


Whisperer.register_serializer(:json,          Whisperer::Serializers::Json)
Whisperer.register_serializer(:json_multiple, Whisperer::Serializers::JsonMultiple)

Whisperer.register_preprocessor(:default_values, Whisperer::Preprocessors::DefaultValues)
Whisperer.register_preprocessor(:response_body,  Whisperer::Preprocessors::ResponseBody)
Whisperer.register_preprocessor(:content_length, Whisperer::Preprocessors::ContentLength)