module Cascadence
  class Config
    include Singleton
    attr_accessor :parallel, :zero_state_generator, :max_thread_count

    def initialize
      @parallel = false
      @zero_state_generator = lambda {}
      @max_thread_count = 5
    end
  end
end