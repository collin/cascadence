
module Cascadence

  module ClassMethods

    attr_reader :cascadence_order
    

    def cascading_order( *order )
      @cascadence_order = order
    end    

  end

end