module Cascadence
  class Commander
    class Flow
      include Singleton

      def run(filepath, times=nil)
        run_tasks _setup_environment_and_get_tasks!(filepath).lazy.cycle(times)
      end

      def run_tasks(tasks)
        Cascadence.runner.run_tasks tasks
      end
      private

      def _setup_environment_and_get_tasks!(filepath)
        abs_file_path = _absolutize_filepath filepath
        files = _get_files_from_filepath abs_file_path
        _setup_environment_from_filepath!(_absolutize_filepath filepath)
        tasks = files.map { |file| _get_task_from_file file }
      end


      def _absolutize_filepath(filepath)
        return filepath if filepath =~ /^\//
        return File.expand_path(filepath) if filepath =~ /^~/
        return File.join(Dir.pwd, filepath)
      end

      def _get_files_from_filepath(filepath)
        return [filepath] if _flow_file? filepath
        return [] unless File.exists? filepath
        Dir[File.join(filepath, "*")].map { |file_or_dir| _get_files_from_filepath file_or_dir }.flatten
      end

      def _flow_file?(filepath)
        (filepath =~ /_flow\.rb$/) && File.file?(filepath)
      end

      def _setup_environment_from_filepath!(filepath)
        require _find_flow_helper_from_filepath filepath
      end

      def _find_flow_helper_from_filepath( filepath )
        _find_flow_helper_from_filepath File.expand_path("..", filepath) unless File.directory? filepath
        raise NameError.new("No flow_helper.rb file found. Be sure you have a flow_helper.rb file in your flows folder!") if filepath == "/"
        Dir[File.join(filepath, "*")].select { |file| _flow_helper? file }.first || _find_flow_helper_from_filepath( File.expand_path("..", filepath) )
      end

      def _flow_helper?(filepath)
        (filepath =~ /\/flow_helper\.rb$/) && File.file?(filepath)
      end

      def _get_task_from_file(file)
        flow = _get_flow_from_file file
        raise NameError.new("Bad flow from #{file}. 
          Remember, all flow class MUST end in Flow and MUST be referenced your flow_helper.rb file. 
          Detected flows: #{Cascadence::Flow.subclasses.to_s}") if flow.nil?
        Cascadence::Task.new(_get_zero_state_generator_from_flow flow) do |state=nil|
          flow.new(state).run_states
        end
      end

      def _get_zero_state_generator_from_flow(flow)
        return flow.zero_state_generator if flow.respond_to? :zero_state_generator
        return Cascadence.config.zero_state_generator if flow == Object || !flow.respond_to?(:parent)
        _get_zero_state_generator_from_flow(flow.parent)
      end

      def _get_flow_from_file(file)
        Cascadence::Flow.subclasses.select { |subclass| _reasonably_matched?(subclass.to_s, file.chomp(".rb")) }.first
      end

      def _reasonably_matched?(str1, str2)
        !(str2.to_s.gsub(/^\/?/, "/") =~ Regexp.new("\/" + str1.to_s.split("::").map(&:underscore).join("/") + "$")).nil?
      end

    end
  end
end