require "spec_helper"

describe Cascadence::Commander::Generate do
  let(:api) { Cascadence::Commander::Generate }
  context "public" do
    describe "#dosomeshit" do
      let(:pubic) { api.start ["dosomeshit", @project_name, RSpec::RootPath] }
      before :each do
        @project_name = "tmp_shit"
        @directory = File.join RSpec::RootPath, @project_name
        FileUtils.rm_r @directory if Dir.exists? @directory
      end
      it "should create the new folder with all the sorts of crap in there" do
        Dir.exists?(@directory).should_not be_true
        pubic
        Dir.exists?(@directory).should be_true
      end
      after :each do
        FileUtils.rm_r @directory if Dir.exists? @directory
      end
    end
  end
  context "private" do
    describe "#_setup_instance_variables!" do

    end
    describe "#_get_source_path" do

    end
    describe "#_get_destination" do

    end
  end

end