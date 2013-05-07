module Cascadence
  class Commander < Thor
    self.default_task(:flow)

    desc "version", "Not implemented yet. That's right, the command that tells you what version of cascadence you're running has not been implemented yet."
    def version
      Cascadence::Commander::Version.instance.run
    end

    desc "flow [FILEPATH]", "Runs the flow specified in the given file. If given a directory, runs all the flows in the directory."
    long_desc <<-LONGDESC
      Runs all the flow specified if <filepath> is a file. If <filepath> is a directory, 
      cascadence will run all the flows in that directory.

      With the -d option, cascadence will loop back after it finishes with its given flows
      and continue to run continously for all eternity (or until it dies)

      With the -p option, specify the path to the file or folder that holds yours

      With the -t option, specify the number of times to run the flows. If -d is specify,
      this value is treated as infinity regardless of what you actually put
    LONGDESC
    method_option :daemonize, :type => :boolean, :desc => "Runs all the flows continously", :default => false, :aliases => "-d"
    method_option :path, :type => :string, :desc => "Specify the filepaths you wish to run", :default => Dir.pwd, :aliases => "-p"
    method_option :times, :type => :numeric, :desc => "Specify the number of times to run", :default => 1, :aliases => "-t"
    def flow
      tasks = Cascadence::Commander::Flow.instance.run(options.path, options.times.to_i)
      if options.daemonize?
        Daemons.daemonize
        Cascadence::Commander::Flow.instance.run_tasks(tasks)
      end
    end

  end
end

Dir[File.join(File.dirname(__FILE__), "commander", "*.rb")].each { |f| require f }