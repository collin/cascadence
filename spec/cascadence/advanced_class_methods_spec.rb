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
        def _white_knight(e)
          self.state += ". But then some white knight (say Ryan Gosling or Ryan Reynolds) comes along, "
          self.state += " saves her and they live happily ever after"
        end
      end
    end
    context "standard usage" do
      let(:storytime) { fairytale.new.run_states.state }
      it "should have the white knight rescue the fair princess from the rape dungeon before the trolls and orcs get to her" do
        storytime.should_not =~ /raped by trolls/
        storytime.should =~ /happily ever after/
      end
    end
    context "fork-inheritance" do
      let(:modern_twist) do
        Class.new(fairytale) do
          fork_after :evil_jealous_queen
          merge_before :raped_repeatedly_by_trolls
          cascading_order :hard_ass_queen, :tough_tiger_mom

          def hard_ass_queen
            self.state += ". Some say the queen was jealous, but queen was an iron lady who lead her country to victory and prosperty through two wars and a recession "
          end

          def tough_tiger_mom
            self.state += ". The queen would not let a ditsy spoiled weak-willed girl next in line to rule would lead the nation to ruin. This girl needed to be tough"
          end

          def raped_repeatedly_by_trolls
            super.raped_repeatedly_by_trolls
            self.state += "but these trolls and orcs are naught by her future subjects - subjects she must rule over."
            self.state += "through trial and tribulation, she comes out stronger and smarter, a fitting successor to her mother."
          end

          private
          def _white_knight(e)
            self.state += ". But then some white knight (say Ryan Gosling or Ryan Reynolds) comes along, "
            self.state += "and she too happily abandons her responsibilities and runs off with this guy."
            self.state += "The queen is bitterly disappointed, decides to turn the country into a democracy."
          end
        end
      end
      let(:starring_julia_roberts) { modern_twist.new.run_states.state }
      it "should have the princess neglecting her responsibilities and running off with the white knight somewhere to fuck" do
        starring_julia_roberts.should_not =~ /stronger and smarter/
        starring_julia_roberts.should_not =~ /happily ever after/
        starring_julia_roberts.should =~ /bitterly disappointed/
      end
    end
  end
end