require 'spec_helper'

describe Cascadence::ClassMethods do
  describe "::rescue_from" do
    class RapeDungeon < ::StandardError; end
    let(:fairytale) do 
      Class.new( Cascadence::Flow ) do
        cascading_order :once_upon_a_time, :fair_princess, :evil_jealous_queen, :get_locked_up, :raped_repeatedly_by_trolls
        rescue_from RapeDungeon, with: "_white_knight"
        def initialize
          self.state = "Disney Presents: "
        end

        def once_upon_a_time
          self.state += "In a land far far away (say Japan) "
        end

        def fair_princess
          self.state += "there lived a fair princess "
        end

        def evil_jealous_queen
          self.state += "who was too fair for the queen "
        end

        def get_locked_up
          self.state += "so into the rape dungeon she goes "
        end

        def raped_repeatedly_by_trolls
          raise RapeDungeon.new "Your princess is about to get raped by trolls and orcs"
          self.states += "where she gets raped by trolls and orcs until she likes it."
        end

        private
        def _white_knight
          self.state += ". But then some white knight (say Ryan Gosling or Ryan Reynolds) comes along, "
          self.state += " saves her and they live happily ever after"
        end
      end
    end
    let(:storytime) { fairytale.new.run_states.state }
    it "should have the white knight rescue the fair princess from the rape dungeon before the trolls and orcs get to her" do
      storytime.should_not =~ /raped by trolls/
      storytime.should =~ /happily ever after/
    end
  end
end