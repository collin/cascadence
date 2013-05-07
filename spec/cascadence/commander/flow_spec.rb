require 'spec_helper'

describe Cascadence::Commander::Flow do
  let(:lolcat) { Cascadence::Commander::Flow.instance }
  context "private" do
    describe "#_get_zero_state_generator_from_flow" do
      module GetZero
        def self.zero_state_generator
          lambda { "get_zero" }
        end
        class Fagbar < Cascadence::Flow
          class HeyzapFlow < ::Cascadence::Flow
            class CrossFlow
              class WeHaveToGoDeeper
                def self.zero_state_generator
                  lambda { "we_have_to_go_deeper" }
                end
              end
            end
          end
        end
      end
      it "should properly give me parents where applicable" do
        GetZero::Fagbar::HeyzapFlow::CrossFlow::WeHaveToGoDeeper.parent.should eq GetZero::Fagbar::HeyzapFlow::CrossFlow
      end
      it "should give me nil for the outer level" do
        GetZero.parent.should == Object
      end
      let(:result) { lolcat.send "_get_zero_state_generator_from_flow", @flow }
      context "warpspeed" do
        before :each do
          @flow = GetZero::Fagbar::HeyzapFlow::CrossFlow
        end
        it "should get me the first zero_state_generator" do
          result.call.should eq "get_zero"
        end
      end
      context "inception" do
        before :each do
          @flow = GetZero::Fagbar::HeyzapFlow::CrossFlow::WeHaveToGoDeeper
        end
        it "should get the closest zero state generator" do
          result.call.should eq "we_have_to_go_deeper"
        end
      end
    end
    describe "#_absolutize_filepath" do
      let(:path) { lolcat.send "_absolutize_filepath", @input }
      let(:result) { path.should eq @expected }
      context "standard usage" do
        before :each do
          @input = "dog"
          @expected = File.join Dir.pwd, @input
        end
        it( "should give me an absolute path to the file regardless of existence") { result }
      end
      context "~" do
        before :each do
          @input = "~/dogfucker"
          @expected = File.join File.expand_path("~"), "dogfucker"
        end
        it( "should expand the tilde to the absolute path") { result }
      end
      context "absolute path" do
        before :each do
          @input = "/home/shinka/something"
          @expected = @input
        end
        it("should not touch the input if it is already absolute") { result }
      end
    end
    describe "#_reasonably_matched?" do
      let(:match) { lambda { |s1, s2| lolcat.send "_reasonably_matched?", s1, s2 } }
      context "true" do
        before :each do
          @expectations = {
            "Dog::Cat::Bat" => "/dog/cat/bat",
            "AssFuck::Shot" => "/ass_fuck/shot",
            "Dicker::BatMan::Robin" => "apples/oranges/dicker/bat_man/robin",
            "Snot" => "/asdf/asdf/asdf/ff/snot"
          }
        end
        it "should be a reasonable match" do
          @expectations.each { |key, val| match.call(key,val).should be_true }
        end
      end
      context "false" do
        before :each do
          @expectations = {
            "Dog::Cat::Bat" => "/fdasf/dog/cat/rat",
            "" => "/anything/really" ,
            "Dicker::AssMan" => "/fd/dicker/ass_man/something"
          }
        end
        it "should not be reasonable matches" do
          @expectations.each { |key,val| match.call(key,val).should_not be_true }
        end
      end
    end
    describe "#_get_flow_from_file" do
      let(:flow) { lolcat.send "_get_flow_from_file", @file }
      let(:expected) { Amazon::MadeiraFlow }
      before :each do
        @file = File.join RSpec::FixturePath, "amazon", "madeira_flow.rb"
        require @file
      end
      context "standard usage" do
        it "should find the flow class in question" do
          flow.should eq expected
        end
      end
      describe "#_get_task_from_file" do
        let(:task) { lolcat.send("_get_task_from_file", @file) }

        it "should be a lambda" do
          task.should respond_to :call
        end

        it "should run and give me the correct result" do
          task.call.state.should eq "initialized123"
        end
      end
    end
    describe "#_find_flow_helper_from_filepath" do
      let(:path) { lolcat.send "_find_flow_helper_from_filepath", @starting }
      context "null case" do
        before :each do
          @starting = File.expand_path __FILE__
        end
        it "should throw an symbol as it cannot find the flow helper" do
          expect { path }.to raise_error(NameError)
        end
      end
      context "dumb case" do
        before :each do
          @starting = File.join RSpec::FixturePath, "flow_helper.rb"
          @expected = @starting
        end
        it "should find it right away" do
          path.should eq @expected
        end
      end
      context "standard usage" do
        before :each do
          @starting = File.join RSpec::FixturePath, "nile", "white_nile"
          @expected = File.join RSpec::FixturePath, "flow_helper.rb"
        end

        it "should find the expected flow helper in the fixture folder" do
          path.should eq @expected
        end
      end
    end
    describe "#_get_files_from_filepath" do
      context "standard usage" do
        let(:files) { lolcat.send( "_get_files_from_filepath", File.join(RSpec::FixturePath) ) }
        before :each do
          @expected = Dir[File.join(RSpec::FixturePath, "*_flow.rb")].map { |f| f }
          @expected += Dir[File.join(RSpec::FixturePath,"**", "*_flow.rb")].map { |f| f }
          @expected += Dir[File.join(RSpec::FixturePath,"**", "**", "*_flow.rb")].map { |f| f }
          @expected.uniq!
        end

        it "should fetch all the files that are flow rubies" do
          files.sort.should eq @expected.sort
        end
      end
      context "null usage" do
        it "should out an empty array if the path doesn't exist" do
          lolcat.send("_get_files_from_filepath", "nigstack").should be_empty
        end
      end
    end
  end
end