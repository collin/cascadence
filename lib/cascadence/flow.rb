
module Cascadence

  # A simple implementation of stateful
  class Flow
    include Stateful
    attr_accessor :state

    def self.inherited(child)
      if child.superclass.respond_to? :cascadence_order
        order = child.superclass.cascadence_order
        child.cascading_order *order
      end
    end
  end

end