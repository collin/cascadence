module Amazon
  class MadeiraFlow < ::Cascadence::Flow
    cascading_order :step1, :step2, :step3

    def initialize(state)
      self.state = state || "initialized"
    end

    def step1
      self.state += "1"
    end

    def step2
      self.state += "2"
    end

    def step3
      self.state += "3"
    end

  end
end
