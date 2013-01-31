require "spec_helper"

describe Cascadence do
  it "should pass the presence sanity test" do
    Cascadence.class.should eq Module
  end

  [:Flow, :ClassMethods, :Stateful, :Helper].each do |constant|
    it "should contain the correct #{constant} constant" do
      Cascadence.const_get(constant).should_not be_nil
    end
  end
end