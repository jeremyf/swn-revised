Dir.glob(File.expand_path("../commands/**/*_command.rb", __FILE__)).each do |filename|
  require filename
end

module Swn
  module Revised
    module Command
      def self.call(command:, from_filename:, **kwargs)
        find(command: command).new(from_filename: from_filename, **kwargs).call
      end
      def self.find(command:)
        Commands.const_get("#{command}Command")
      rescue NameError
        $stderr.puts "Could not find command '#{command}Command', fallback to SkipCommand"
        Commands.const_get("SkipCommand")
      end
    end
  end
end
