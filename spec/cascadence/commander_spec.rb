require "spec_helper"

describe Cascadence::Commander do
  let(:lolcat) { Cascadence::Commander.new }
  context "public api" do
    describe "#flow" do
      let(:result) { lolcat.flow File.join(RSpec::FixturePath, "amazon", "madeira_flow.rb") }
      it "should run the flow stated" do
        result.should_not be_empty
      end
    end
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