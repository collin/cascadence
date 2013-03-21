module Cascadence
  class Task
    def initialize(zero_state_generator=nil, &block)
      @block = block
      @zstate_gen = zero_state_generator
      @zstate_gen ||= Cascadence.config.zero_state_generator 
    end

    def call
      @block.call @zstate_gen.call
    end
  end
end

