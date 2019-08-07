require 'dry-initializer'
module Swn
  module Revised
    module Commands
      class SkipCommand
        extend Dry::Initializer
        option :from_filename

        def call
        end
      end
    end
  end
end
