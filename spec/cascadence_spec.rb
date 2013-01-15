require "spec_helper"

class CascadeTest
  include Cascadence::Stateful

  cascading_order :step1, :step2, :step3

  attr_reader :foo

  def step1
    @foo = 2
  end

  def step2
    @foo *= 3
  end

  def step3
    @foo -= 5
  end
end

describe Cascadence do

  before :each do
    @test = CascadeTest.new
  end

  describe "CascadeTest.new" do

    it "should have the cascadence_position property" do
      @test.should respond_to :cascadence_position
    end

    it "should have a null current step" do
      @test.current_step_name.should be_nil
    end

    it "should have step1 as it's next step" do
      @test.next_step_name.should eq :step1
    end

  end

  describe "CascadeTest" do

    it "should have the cascadence_order property" do
      CascadeTest.should respond_to :cascadence_order
    end 

  end

  describe "run next" do 

    it "should run the first thing specified by the cascadence order" do
      @test.run_next.foo.should eq 2
    end

    it "should run the first two steps specified by the cascadence order" do
      @test.run_next.tap do |cascade|
        cascade.foo.should eq 2
      end.run_next.foo.should eq 6
    end

    it "should run all 3 steps specified by the cascadence order" do
      @test.run_next.run_next.run_next.foo.should eq 1
    end 

    it "should not do anything to the result on extra calls" do
      exp = [2,6,1]
      (0..6).to_a.inject(@test) do |mem, nex|
        n = nex < 3 ? nex : 2
        res = mem.run_next
        res.class.should eq CascadeTest
        res.foo.should_not be_nil
        exp[n].should_not be_nil
        res.foo.should eq exp[n]
        res
      end.foo.should eq exp.last
    end 
  end 

  describe "run states" do

    let(:final) { @test.run_states }

    it "should have a valid final state" do
      final.should_not be_nil
    end

    it "should have maintained the correct cascadence order" do
      final.class.cascadence_order.should eq [:step1, :step2, :step3]
    end 

    it "should have advanced to the final cascadence position" do
      final.cascadence_position.should eq 2
    end 

    it "should have the correct cascadence result" do
      final.foo.should eq 1
    end

  end

  describe "run until" do
    
    it "should run to a specified block" do
      result = @test.run_until do |state|
        :step3 == state.current_step_name
      end
      result.current_step_name.should eq :step3
      result.foo.should eq 1
    end

    it "should run to a specified order" do
      @test.run_until(:step2).foo.should eq 6
    end

    it "should have the same result when calling successively" do
      @test.run_until.run_until.run_until.foo.should eq 1
    end

  end 

end