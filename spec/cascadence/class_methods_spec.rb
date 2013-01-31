require 'spec_helper'

describe Cascadence::ClassMethods do

  let(:life) do 
    Class.new( Cascadence::Flow ) do
      cascading_order :childhood, :teenage, :adulthood, :marriage, :mid_age, :old_age, :death

      def initialize
        self.state = "created"
      end

      def childhood
        self.state += "-happy"
      end

      def teenage
        self.state += "-misunderstood"
      end

      def adulthood
        self.state += "-responsible"
      end

      def marriage
        self.state += "-busy"
      end

      def mid_age
        self.state += "-content"
      end

      def old_age
        self.state += "-tired"
      end

      def death
        self.state += "-rip"
      end
    end
  end

  describe "position" do

    it "should give me the correct numerical value for the index command" do
      life.cascadence_order.index(:teenage).should eq 1
    end
  end

  describe "inheritance" do
    let(:japanese) { Class.new(life) }

    describe "defaults" do

      describe "#cascadence_order" do
        subject { japanese.cascadence_order }

        it "should be inherited from the parent cascadence order" do
          should eq life.cascadence_order
        end
      end

      describe "#run_states" do
        subject { japanese.new.run_states.state }

        it "should match exactly the states as run by the parent" do
          should eq life.new.run_states.state
        end
      end

    end

    describe "difference" do

      before :each do 
        japanese.class_exec do
          def loli
            self.state += "-kawaii"
          end

          def schoolgirl
            self.state += "-chikan"
          end

          def ol
            self.state += "-alcoholic"
          end

          def settle
            self.state += "-ntr"
          end

          def mid_age
            self.state += "-depressed"
          end
        end
      end

      describe "position" do
        it "should have the correct position" do
          japanese.fork_after :childhood
          japanese.merge_before :mid_age
          japanese.cascadence_order.should eq [:childhood, :teenage, :adulthood, :marriage, :mid_age, :old_age, :death]
          japanese.cascading_order :loli, :schoolgirl, :ol, :settle
          japanese.cascadence_order.should eq [:childhood, :loli, :schoolgirl, :ol, :settle, :mid_age, :old_age, :death]
        end
      end

      describe "results" do
        before :each do
          japanese.fork_after :childhood
          japanese.merge_before :mid_age
          japanese.cascading_order :loli, :schoolgirl, :ol, :settle
        end
        it "should have a different cascadence order than the parent class" do
          life.cascadence_order.should_not eq japanese.cascadence_order
        end

        it "should result in a different terminal state when the states are run" do
          life.new.run_states.state.should_not eq japanese.new.run_states.state
        end
      end

    end

  end

end  