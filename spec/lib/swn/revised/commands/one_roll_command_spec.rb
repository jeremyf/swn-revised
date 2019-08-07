require 'spec_helper'
require 'swn/revised/commands/one_roll_command'

module Swn
  module Revised
    module Commands
      RSpec.describe OneRollCommand do
        let(:filename) { File.join(GEM_ROOT, "spec/fixtures/table-00305.tsv") }
        let(:type) { 'npc' }

        let(:one_roll_command) { described_class.new(type: type, filename: filename) }
        describe '#call' do
          subject { one_roll_command.call }
          it "writes a one-roll structured sub-table" do
            subject
          end
        end
      end
    end
  end
end
