require "spec_helper"

Dir[File.join(File.dirname(__FILE__), "cascadence", "*_spec.rb")].each do |source|
  require source
end

describe Cascadence do
  it "should pass the presence sanity test" do
    Cascadence.class.should eq Module
  end
end