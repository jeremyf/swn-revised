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
    class PlanetaryTagEntry < Base
      include Comparable
      def <=>(other)
        index <=> other.index
      end

      LABELS = {
        "description" => "Description",
        "tag" => "Tag",
        "enemies" => "Enemies",
        "friends" => "Friends",
        "complications" => "Complications",
        "things" => "Things",
        "places" => "Places"
      }
      def label_for(key)
        LABELS.fetch(key)
      end

      option :from_filename
      option :entry
      option :index
      option :command
    end
    class PlanetaryTagsTable < Base
      option :sub_tables
      def write!
        open do |file|
          file.puts "# Master table of all planetary tags"
          sub_tables.sort.each_with_index do |sub_table, i|
            index = i + 1
            row = "#{index}\t"
            cells = []
            sub_table.entry.each_key do |key|
              next if key == "index"
              cells << "#{sub_table.label_for(key)}:\\t{#{sub_table.table_name}[#{key}]}"
            end
            row += cells.join("\\n\\n")
            file.puts row
          end
        end
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
          comments << "#\t#{subtable.label} {#{subtable.table_name}}"
          entry_elements << "#{subtable.label}:\\t{#{subtable.table_name}}"
        end
        open do |f|
          f.puts "# One Roll Table for #{table_name}"
          f.puts comments.sort
          f.puts "1\t#{entry_elements.sort.join('\n')}"
        end
      end
    end
  end
end
