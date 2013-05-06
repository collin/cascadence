module Cascadence
  class Commander < Thor

    desc "version", "Not implemented yet. That's right, the command that tells you what version of cascadence you're running has not been implemented yet."
    def version
      Cascadence::Commander::Version.instance.run
    end

    desc "flow [FILEPATH]", "Runs the flow specified in the given file. If given a directory, runs all the flows in the directory."
    def flow(filepath=Dir.pwd)
      Cascadence::Commander::Flow.instance.run(filepath)
    end

  end
end

Dir[File.join(File.dirname(__FILE__), "commander", "*.rb")].each { |f| require f }