require 'spec_helper'

describe Cascadence::Runner do
  let(:runner) { Cascadence::Runner.instance }
  let(:task) { Class.new }
  before :each do
    task.any_instance.should_receive(:call)
    @tasks = 1.upto(5).map { |a| task.new }
  end
  context "public api" do
    describe "#run_tasks" do
      let(:doitfaggot) { runner.run_tasks @tasks }
      before(:each) { Cascadence.config.parallel = true }
      it "should be okay" do
        expect { doitfaggot }.not_to raise_error
      end
      after(:each) { Cascadence.config.parallel = false }
    end
  end
  context "private" do
    describe "#_run_parallel" do
      let(:doitfaggot) { runner.send("_run_parallel", @tasks ) }    
      it "should be okay" do
        expect { doitfaggot }.not_to raise_error
      end
    end
  end
end