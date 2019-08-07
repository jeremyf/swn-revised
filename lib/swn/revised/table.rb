require 'dry-initializer'
module Swn
  module Revised
    class Base
      extend Dry::Initializer
      option :basename
      option :extension, default: -> { '.tsv' }

      def table_name
        File.basename(basename, extension)
      end

      def open(mode: "w+", &block)
        File.open(filename, mode) do |f|
          yield(f)
        end
      end

      def filename
        File.join(File.expand_path("../../../../data/converted", __FILE__), basename)
      end

    end
    class OneRollSubtable < Base
      option :from_filename
      option :command
      option :label
    end
    class OneRollTable < Base
      option :subtables, default: -> { Array.new }, reader: :private
      def add(subtable:)
        subtables << subtable
      end
      def package_up!
        comments = ["# Includes subtables:"]
        entry_elements = []
        subtables.each do |subtable|
          comments << "#\t#{subtable.label} (#{subtable.table_name})"
          entry_elements << "#{subtable.label}:\t{#{subtable.table_name}}"
        end
        open do |f|
          f.puts "# One Roll Table for #{table_name}"
          f.puts comments.sort
          f.puts "1 | #{entry_elements.sort.join('\n')}"
        end
      end
    end
  end
end
