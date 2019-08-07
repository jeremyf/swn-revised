require 'swn/revised/command'
require 'swn/revised/extracted_table_map'
require 'swn/revised/table_registry'
module Swn
  module Revised
    def self.convert!(source_directory: File.expand_path("../../../data/extracted_tables/", __FILE__))
      table_registry = TableRegistry.new(source_directory: source_directory)
      EXTRACTED_TABLE_MAP.each_pair do |from_filename, params|
        from_filename = File.join(source_directory, from_filename)
        Command.call(table_registry: table_registry, from_filename: from_filename, **params)
      end
      table_registry.package!
    end
  end
end
