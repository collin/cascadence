require 'spec_helper'

describe Cascadence::Runner do
  let(:runner) { Cascadence::Runner.instance }
  let(:task) do
    Class.new do
      def call
        sleep 2
        make_sure_this_gets_called!
        puts "thread exiting"
        return 13
      end
    end
  end
  
  context "running tasks" do
    before :each do
      task.any_instance.should_receive(:make_sure_this_gets_called!)
      @tasks = 1.upto(7).map { |a| task.new }.to_enum
    end
    context "public api" do
      describe "#run_tasks" do
        let(:run_my_junk) { runner.run_tasks @tasks }
        before(:each) { Cascadence.config.parallel = true }
        it "should be okay" do
          expect { run_my_junk }.to raise_error StopIteration
        end
        after(:each) { Cascadence.config.parallel = false }
      end
    end
    context "private" do
      describe "#_run_parallel" do
        let(:run_my_junk) { runner.send("_run_parallel", @tasks ) }    
        it "should be okay" do
          expect { run_my_junk }.to raise_error StopIteration
        end
      end
    end
  end

  context "private utility functions" do
    describe "#_implements_enumerable?" do
      let(:result) { runner.send("_implements_enumerable?", @something) }
      context "enumerator" do
        before(:each) { @something = [].to_enum }
        it "should be trivially true for things that are enumerable" do
          result.should be_true
        end  
      end
      context "lazy enumerator" do
        before(:each) { @something = [].lazy }
        it "should also be true for lazy enumerators" do
          result.should be_true
        end
      end
      context "custom half-ass objects" do
        before(:each) do
          halfass = Class.new do
            def next; end
            def peek; end
          end
          @something = halfass.new
        end
        it "should be true for objects as long as it implements next and peek" do
          result.should be_true
        end
      end
      context "false" do
        before(:each) { @something = Object.new }
        it "should not be true for just random objects" do
          result.should be_false
        end
      end
    end
  end
end