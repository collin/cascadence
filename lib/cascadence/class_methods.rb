
module Cascadence

  module ClassMethods
    # Yes, I realize this is confusing
    # I'm sorry for code-gulfing
    # TODO: Write this class so we don't depend so heavily
    # on recusion and "lazy evaluation" to get the ordering.
    # This is probably 100% necessary if this project were
    # ever to get big and require junk
    def cascadence_order
      @cascadence_order ||= []
      @forked_position ||= []
      @merge_position ||= []
      unless @cascadence_order.nil?
        Helper.generate_tributary(@cascadence_order.reverse, @forked_position.clone, @merge_position.clone)
      end
    end

    def cascading_order( *order )
      @cascadence_order ||= []
      @cascadence_order << order
    end    

    def fork_after( location )
      @forked_position ||= []
      index = cascadence_order.index location
      @forked_position << (index + 1)
    end

    def merge_before( location )
      @merge_position ||= []
      index = cascadence_order.index location
      @merge_position << (index - 1)
    end

    def flows_into( another_stream )
      Cascadence::Confluence.merge_streams( self, another_stream ) do |estate|
        if block_given?
          yield estate
        else
          [estate]
        end
      end
    end

    def cascadence_rescuers
      @cascadence_rescuers ||= {}
    end

    def rescue_from(error_class, with: "method_missing")
      @cascadence_rescuers ||= {}
      @cascadence_rescuers[error_class] = with
      raise NoMethodError.new("Okay you tool, you can't rescue with nothing") if "method_missing" == with
    end

  end

end