module Cascadence
  module Confluence
    class << self
      def merge_streams(flowa, flowb, &block)
        flow = Class.new(::Cascadence::Flow) do 
          class << self; attr_accessor :pipe_merger, :state_converter end
          cascading_order :pipe_merge
          def initialize(*args)
            self.state = args
          end
          def pipe_merge
            self.state = self.class.pipe_merger.call(self).run_states.state
          end
          
          def _convert_state(post_a_state)
            self.class.state_converter.call post_a_state
          end
        end
        flow.pipe_merger = lambda { |f| flowb.new *f._convert_state(flowa.new(*f.state).run_states.state) }
        flow.state_converter = lambda { |s| yield s }
        return flow
      end
    end
  end
end