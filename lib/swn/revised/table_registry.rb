require 'dry-initializer'
require 'swn/revised/table'
module Swn
  module Revised
    class TableRegistry
      extend Dry::Initializer
      option :source_directory
      option :registry, default: -> { Array.new }, reader: :private

      def register(table:)
        registry << table
      end

      def package!
        package_up_one_rolls!
        package_up_planetary_tags!
      end

      private

      def package_up_one_rolls!
        one_rolls = {}
        registry.each do |table|
          next unless table.command.is_a?(Commands::OneRollCommand)
          one_rolls[table.command.type] ||= []
          one_rolls[table.command.type] << table
        end
        one_rolls.each_key do |key|
          one_roll_table = OneRollTable.new(basename: "#{key}.tsv", extension: ".tsv")
          one_rolls.fetch(key).each do |subtable|
            one_roll_table.add(subtable: subtable)
          end
          one_roll_table.package_up!
        end
      end
      def package_up_planetary_tags!
        sub_tables = []
        registry.each do |table|
          next unless table.command.is_a?(Commands::PlanetaryTagCommand)
          sub_tables << table
        end
        table = PlanetaryTagsTable.new(basename: "planetary-tag.tsv", extension: ".tsv", sub_tables: sub_tables)
        table.write!
      end
    end
  end
end
