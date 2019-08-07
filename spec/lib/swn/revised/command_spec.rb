require 'spec_helper'
require 'swn/revised/command'

module Swn
  module Revised
    RSpec.describe Command do
      describe '.find' do
        it "finds 'OneRoll' as the OneRollCommand" do
          expect(described_class.find(command: "OneRoll")).to eq(Commands::OneRollCommand)
        end
      end
    end
  end
end
