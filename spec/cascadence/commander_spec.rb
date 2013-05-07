require "spec_helper"

describe Cascadence::Commander do
  describe "::start" do
    before :each do
      @argv = "-p #{File.join(RSpec::FixturePath, "amazon", "madeira_flow.rb")}".split(" ")
      @thorify = lambda { |argv| Cascadence::Commander.start argv }
    end

    context "flow -p" do
      it "should run the flow stated" do
        @thorify.call @argv
      end
    end
    context "flow -t 2 -p" do
      it "should run the flow twice" do
        @thorify.call @argv
      end
    end
    context "flow -d -p" do
      before :each do
        @argv.unshift " -d "
      end
      it "should run the flow forever" do
        pending "Testing this involves solving Turing's Halting Problem, which I can't do. Sorry"
      end
    end
  end
  context "instance" do
    let(:lolcat) { Cascadence::Commander.new }
    context "public api" do
      describe "#version" do
        let(:expected) { File.read File.expand_path("../../../VERSION", __FILE__) }
        let(:actual) { lolcat.version }
        it "should get the version as specified in the VERSION file" do
          actual.should eq expected
        end
      end
      describe "#generate" do
        it "should have tests" do
          pending "write tests here!"
        end
      end
    end
  end
end