require 'spec_helper'

describe Cascadence::Flow do
  let(:euphrates) do
    Class.new( Cascadence::Flow ) do
      cascading_order :eden, :babylon, :gulf

      def initialize
        self.state = "created"
      end

      def eden
        self.state += "-innocence"
      end

      def babylon
        self.state += "-prosperity"
      end

      def gulf
        self.state += "-downfall"
      end

    end
  end

  let(:tigris) do
    Class.new( euphrates ) do
      fork_after :eden
      merge_before :gulf
      cascading_order :sumer, :israel
      def sumer
        self.state += "-discovery"
      end

      def israel
        self.state += "-arrogance"
      end
    end
  end

  describe "#cascadence_order" do

    context "parent" do
      subject { euphrates.cascadence_order }

      it "should remain unchanged from what it was" do
        should eq [:eden, :babylon, :gulf]
      end
    end

    context "child" do
      subject { tigris.cascadence_order }

      it "should have been forked from the parent cascadence order" do
        should eq [:eden, :sumer, :israel, :gulf]
      end

    end
  end

  describe "#run_state" do

    describe "parent" do
      subject { euphrates.new.run_states.state }

      it "should generate the expected state without regard to forks" do
        should eq "created-innocence-prosperity-downfall"
      end
    end

    describe "child" do
      subject { tigris.new.run_states.state }

      it "should have the right states to run" do
        tigris.cascadence_order.should eq [:eden, :sumer, :israel, :gulf]
        tigris.new.run_states.state.should eq "created-innocence-discovery-arrogance-downfall"
      end
      it "should generate the expected state after succesful forking from the parent" do
        should eq "created-innocence-discovery-arrogance-downfall"
      end
    end

  end

end   