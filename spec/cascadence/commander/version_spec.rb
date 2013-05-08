require 'spec_helper'

describe Cascadence::Commander::Version do
  let(:api) { Cascadence::Commander::Version.instance }
  let(:expected) { File.read File.expand_path("../../../../VERSION", __FILE__) }
  it "should not be retarded" do
    expected.should =~ /\d\.\d\.\d/
  end
  specify { api.run.should eq expected }
end