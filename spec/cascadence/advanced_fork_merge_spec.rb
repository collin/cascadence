require 'spec_helper'

describe Cascadence::Flow do
  let(:amazon) do
    Class.new(Cascadence::Flow) do
      cascading_order :step1, :step2, :step3, :stepcrap
      def initialize
        self.state = "initialize"
      end

      def step1
        self.state += "1"
      end

      def step2
        self.state += "2"
      end

      def step3
        self.state += "3"
      end

      def stepcrap
        self.state += "crap"
      end
    end
  end
  context "preemptivization" do
    let(:amazon_zero) do
      Class.new(amazon) do
        merge_before :step1
        cascading_order :step0

        def step0
          self.state += "0"
        end
      end
    end
    describe "#cascadence_order" do
      context "child" do
        subject { amazon_zero.cascadence_order }

        it "should be a continuation of the parent" do
          pending "Not going to worry about this unless this is actually needed"
          should eq [:step0, :step1, :step2, :step3, :stepcrap]
        end
      end
      context "parent" do
        subject { amazon.cascadence_order }

        it "should be as expected from the declaration" do
          should eq [:step1, :step2, :step3, :stepcrap]
        end
      end
    end
    describe "#run_states" do
      context "child" do
        subject { amazon_zero.new.run_states.state }

        it "should give the expected state value" do
          pending "Not going to worry about this unless this is actually needed"
          should eq "initialize0123crap"
        end
      end
      context "parent" do
        subject {amazon.new.run_states.state }
        it "should give the expected parent state value" do
          should eq "initialize123crap"
        end
      end
    end
  end
  context "continuation" do
    let(:amazon_prime) do
      Class.new(amazon) do
        fork_after :step3
        cascading_order :step4, :step5

        def step4
          self.state += "4"
        end

        def step5
          self.state += "5"
        end
      end
    end

    describe "#cascadence_order" do
      context "child" do
        subject { amazon_prime.cascadence_order }

        it "should be a continuation of the parent" do
          should eq [:step1, :step2, :step3, :step4, :step5]
        end
      end
      context "parent" do
        subject { amazon.cascadence_order }

        it "should be as expected from the declaration" do
          should eq [:step1, :step2, :step3, :stepcrap]
        end
      end
    end

    describe "#run_states" do
      context "child" do
        subject { amazon_prime.new.run_states.state }

        it "should give the expected state value" do
          should eq "initialize12345"
        end
      end
      context "parent" do
        subject {amazon.new.run_states.state }
        it "should give the expected parent state value" do
          should eq "initialize123crap"
        end
      end
    end
  end
end