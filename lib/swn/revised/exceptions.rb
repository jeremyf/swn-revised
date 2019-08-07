module Swn
  module Revised
    class RuntimeError < ::RuntimeError
    end
    class CommandProcessingError < RuntimeError
    end
  end
end
