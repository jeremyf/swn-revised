require 'dry-initializer'
require 'swn/revised/table'
require 'swn/revised/exceptions'
module Swn
  module Revised
    module Commands
      class PlanetaryTagCommand
        extend Dry::Initializer
        option :table_registry
        option :from_filename

        KEY_MAP = {
          "e" => "enemies",
          "f" => "friends",
          "c" => "complications",
          "t" => "things",
          "p" => "places"
        }.freeze
        def call
          content = File.read(from_filename).split("\n")
          content.shift # drop preamble row
          label_row = content.shift.strip
          label = label_row.split(":")[1..-1].join(":").strip
          entry = {}
          indices = ["tag", "description"]
          entry["tag"] = label
          entry["description"] = content.shift
          content.each do |row|
            key, value = row.split("\t")
            cell = KEY_MAP.fetch(key.strip.downcase)
            entry[cell] = value.strip
            indices << cell
          end
          target_basename = "planetary-tag.#{for_filename(entry["tag"])}.tsv"
          table = PlanetaryTagEntry.new(command: self, from_filename: from_filename, index: for_filename(label), basename: target_basename, entry: entry)
          table.open do |t|
            indices.each do |index|
              t.puts "#{index}\t#{entry.fetch(index)}"
            end
          end
          table_registry.register(table: table)
        end

        private
        def for_filename(string)
          string.strip.downcase.gsub(/\W+/,'-').sub(/^-+/, '').sub(/-+$/, '')
        end
      end
    end
  end
end
