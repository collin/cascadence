require 'spec_helper'

describe Cascadence::Helper do
  let(:api) { Cascadence::Helper }

  describe "::collect_superclasses" do
    let(:flow) { Class.new(Cascadence::Flow) }
    before :each do
      @expected = [BasicObject, Object, Cascadence::Flow, flow]
    end
    it "should give me all the superclasses in an array with the most basic being first" do
      api.collect_superclasses(flow).should eq @expected
    end
  end

  describe "#generate_tributary" do
    context "standard usage" do
      before :each do
        @arrays = [
          ["o","t"] ,
          ["a","g"] ,
          ["f","b","c","g"]
        ]
        @starts = [1]
        @finishes = [2]
        @expected = ["f","a","g","g","o","t"]
      end

      it "should reduce the given array to the expected array" do
        api.generate_tributary(@arrays, @starts, @finishes).should eq @expected
      end

      it "should work with simpler arrays also" do
        arrays = [
          ['a','g','g','o'] ,
          ['f','b','b','b','t']
        ]
        start = [1]
        merge = [3]
        api.generate_tributary(arrays, start, merge).should eq @expected
      end
    end

    context "weird input" do
      before :each do
        @arrays = [
          ["o","t"] ,
          ["a","g"] ,
          ["f","b","c","g"]
        ]
        @starts = [1]
        @finishes = [2]
        @expected = ["f","a","g","g","o","t"]
      end

      it "should return the array as is" do
        api.generate_tributary([[1,2,3,4]]).should eq [1,2,3,4]
      end

      it "should entirely ignore merge points if no fork points were specified" do
        api.generate_tributary(@arrays, [1], [23,234,23,23,3,2]).should eq @expected
      end

      it "should entirely replace to the end if no merge points were specified" do
        arrays = [
          "I love eating food".split(" ") ,
          "big throbbing ipad".split(" ") ,
          "explicitive deleted".split(" ")
        ].reverse
        api.generate_tributary(arrays, [4,2]).join(" ").should eq "I love big throbbing explicitive deleted"
      end
    end

    context "bad input" do

      it "should do as much as possible and ignore the rest of the starts if the initial array isn't long enough" do
        api.generate_tributary([[1,2,3,4,5], [10,2,3,4]], [5,4,3,1]).should eq [10,1,2,3,4,5]
      end

      it "should throw an error if you attempt to start well after the array" do
        expect do
          api.generate_tributary([[1,2,3,4],[1,2,3]], [99])
        end.to throw_symbol :OutOfRange
      end
    end

  end

  describe "#replace_in_part" do

    it "should replace the specified chunk in a given array" do
      original = "f a b t".split " "
      chunk = "g g o".split " "
      api.replace_in_part( original, chunk, 2, 2).join.should eq "faggot"
      original.join.should eq "fabt"
      chunk.join.should eq "ggo"
    end
  end

  it "should replace as much as possible and then just append the rest in the case the replacement is longer than the original" do
    original = "asd".split ""
    chunk = "sshole".split ""
    api.replace_in_part(original, chunk, 1).join.should eq "asshole"
  end

  it "should return the chunk if the original array is empty; it should ignore the other options" do
    api.replace_in_part([], [1,2,3,4], 42).should eq [1,2,3,4]
  end

  it "should return a cropped version of the array if the replacement chunk is empty" do
    api.replace_in_part([1,2,3,4], [], 2).should eq [1,2]
    api.replace_in_part([0,1,2,3,4,5,6,7],[], 2, 4).should eq [0,1,5,6,7]
  end
  

end