module Whisperer
  class Storage
    @cassette_records = ThreadSafe::Hash.new

    class << self
      attr_accessor :cassette_records
      private :cassette_records=

      def define(name, options = {}, &block)
        dsl = Dsl.build
        dsl.instance_eval &block
        record = dsl.container

        if options[:parent]
          original_record = cassette_record(options[:parent])

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

      def cassette_record(name)
        cassette_records[name]
      end

      def reset_storage
        @cassette_records.clear
      end
    end
  end
end