module Amazon
  class MadeiraFlow < ::Cascadence::Flow
    cascading_order :step1, :step2, :step3

    def initialize(state)
      self.state = state || "initialized"
      puts state
    end

    def step1
      self.state += "1"
      puts state
    end

    def step2
      self.state += "2"
      puts state
    end

    def step3
      self.state += "3"
      puts state
    end

  end
end
