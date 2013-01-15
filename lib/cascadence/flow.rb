
module Cascadence

  # A simple implementation of stateful
  class Flow
    include Stateful
    attr_accessor :state
  end

end