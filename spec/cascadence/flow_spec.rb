require 'spec_helper'

class FlowTest < Cascadence::Flow

  cascading_order :step1, :step2, :step3, :step4

  def initialize
    self.state = "initialized"
  end

  def step1
    self.state += "-step1"
  end

  def step2
    self.state += "-step2"
  end

  def step3
    self.state += "-step3"
  end

  def step4
    self.state += "-step4"
  end

end

describe Cascadence::Flow do

  before :each do
    @flow = FlowTest.new
  end

  describe "sanity" do

    it "should be an instance of flowtest" do
      @flow.class.should eq FlowTest
    end

    it "should respond to state" do
      @flow.should respond_to :state
      @flow.should respond_to :state=
      @flow.state.should eq "initialized"
    end 

    it "should be an instance of cascadence::flow" do
      FlowTest.superclass.should eq Cascadence::Flow
    end

  end

  describe "#subclasses" do
    let(:inherit) { Class.new(Cascadence::Flow) }

    it "should change the count of subclasses by 1" do
      expect { inherit }.to change(Cascadence::Flow.subclasses, :count).by(1)
    end
    it "should include this new mixed in class as a subclass of cascadence flow" do
      Cascadence::Flow.subclasses.should include inherit
    end
  end

  describe "#run_states" do

    before(:each) { @expected = "initialized-step1-step2-step3-step4" }
    let(:actual) { @flow.run_states }

    it "should run all four states in the specified cascading order" do
      actual.state.should eq @expected
    end

  end

end
