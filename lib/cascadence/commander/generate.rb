module Cascadence
  class Commander
    class Generate < Thor
      include Singleton
      include Thor::Actions
      attr_accessor :project_name, :project_dir

      desc "dosomeshit [FLOWNAME] [PROJECTDIR]", "Generates a project name."
      def dosomeshit(flowname, project_dir=Dir.pwd)
        _setup_instance_variables!(flowname, project_dir)
        directory _get_source_path, _get_destination
      end

      def self.source_root
        File.expand_path("../../templates", __FILE__)
      end

      private

      def _setup_instance_variables!(flowname, project_dir)
        @project_name = flowname
        @project_dir = project_dir
      end

      def _get_source_path
        self.class.source_root
      end

      def _get_destination
        File.join(project_dir, project_name, "flows")
      end

    end
  end
end