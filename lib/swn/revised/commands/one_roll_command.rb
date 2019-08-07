require 'dry-initializer'
require 'swn/revised/table'
module Swn
  module Revised
    class RuntimeError < ::RuntimeError
    end
    class CommandProcessingError < RuntimeError
    end

    module Commands
      class OneRollCommand
        extend Dry::Initializer
        option :table_registry
        option :from_filename
        option :type

        def call
          content = File.read(from_filename).split("\n")
          dice_to_use = content.shift.strip
          label_row = content.shift.strip
          entries = content
          expected_count = dice_to_use.gsub(/^.+d(\d+)$/, '\1').to_i
          if entries.count != expected_count
            raise CommandProcessingError, "Expected number of entries (#{entries.count}) to equal dice size (#{expected_count})"
          end
          label_slugs = label_row.split(",")
          label_slugs.shift
          one_roll_label = label_slugs.join(",").strip
          target_basename = "#{for_filename(type)}-#{for_filename(one_roll_label)}.tsv"
          table = OneRollSubtable.new(from_filename: from_filename, basename: target_basename, command: self, label: one_roll_label)
          table.open do |t|
            t.puts "# One Role Entry for: #{type} (#{one_roll_label})"
            t.puts "INDEX\t#{one_roll_label}"
            entries.each do |entry|
              t.puts entry
            end
          end
          table_registry.add(table: table)
        end

        private

        def for_filename(string)
          string.strip.downcase.gsub(/\W+/,'-')
        end
      end
    end
  end
end
