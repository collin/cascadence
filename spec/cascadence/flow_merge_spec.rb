require 'spec_helper'

describe Cascadence::Flow do
  describe "::flow_into" do
    let(:stream1) do
      Class.new(Cascadence::Flow) do
        cascading_order :step1, :step2
        def initialize(seed_state=nil)
          self.state = seed_state || 0
        end

        def step1
          self.state += 1
        end

        def step2
          self.state += 2
        end
      end
    end
    context "one-to-one" do
      before :each do
        @stream2 = stream1.flows_into(stream1)
        @stream3 = stream1.flows_into(stream1).flows_into(stream1)
      end
      context "basics" do
        it "should still be a cascadence flow" do
          @stream2.superclass.should eq Cascadence::Flow
          @stream3.superclass.should eq Cascadence::Flow
        end
        describe "#run_states" do
          let(:state) { @stream2.new(0).run_states.state }
          let(:state3) { @stream3.new(0).run_states.state }
          it "should pipe the first stream into the second stream and transfer the states as such" do
            state.should eq (0 + 1 + 2 + 1 + 2)
            state3.should eq (0 + 1 + 2 + 1 + 2 + 1 + 2)
          end
        end
      end
    end

    context "one-to-many" do
      let(:parent) do
        Class.new(Cascadence::Flow) do
          cascading_order :step1, :step2
          def initialize
            self.state = [0,0]
          end

          def step1
            _inc_first 1
            _inc_second -1
          end

          def step2
            _inc_first 2
            _inc_second -2
          end
          
          private
          def _inc_first(a)
            self.state[0] += a
          end

          def _inc_second(a)
            self.state[1] += a
          end
        end
      end
      before :each do
        @stream = parent.flows_into(stream1) { |pstate| pstate[0] }
        @alt_stream = parent.flows_into(stream1) { |pstate| pstate[1] }
      end
      it "should still be a flow" do
        @stream.superclass.should eq Cascadence::Flow
        @alt_stream.superclass.should eq Cascadence::Flow
      end
      describe "#run_states" do
        let(:first_state) { @stream.new.run_states.state }
        let(:alt_state) { @alt_stream.new.run_states.state }
        it "should produce the terminal state" do
          first_state.should eq 6
          alt_state.should eq 0
        end
      end
    end
  end
end