module Cascadence
  class Task
    def initialize(zero_state_generator=nil, &block)
      Cascadence.say "Creating a new task"
      @block = block
      @zstate_gen = zero_state_generator
      @zstate_gen ||= Cascadence.config.zero_state_generator 
    end

    def call
      Cascadence.say "Task getting called"
      @block.call @zstate_gen.call
    end
  end
end

