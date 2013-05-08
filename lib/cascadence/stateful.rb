module Cascadence

  module Stateful

    def self.included( base )
      base.extend ClassMethods
      base.class_exec do
        attr_reader :cascadence_position
      end # class_exec
    end

    def run_states
      run_until :end
    end

    def run_until( target=nil )
      
      return run_next if target.nil? and !block_given?
      
      if block_given?
        while !_cascadence_end? and !yield(self)
          run_next
        end
        return self
      end
      
      case target.class.to_s
      when "String", "Symbol"
        return run_until { |state| state.current_step_name.to_s == target.to_s }
      when "Fixnum", "Integer"
        return run_until { |state| state.cascadence_position == target }
      else
        throw "Bad input error." unless target.respond_to? :call
        return run_until { |state| target.call state }
      end
    end

    def run_next
      _debug_helper

      unless next_step_name.nil?
        send next_step_name
        _increment_cascadence
      end
      self
    end

    def current_step_name
      return nil if cascadence_position.nil?
      self.class.cascadence_order[cascadence_position]
    end

    def next_step_name
      return self.class.cascadence_order.first if cascadence_position.nil?
      self.class.cascadence_order[cascadence_position+1]
    end

    private

    def _cascadence_end?
      return false if cascadence_position.nil?
      cascadence_position >= self.class.cascadence_order.count - 1
    end

    def _increment_cascadence
      if @cascadence_position.nil?
        @cascadence_position = 0
      else
        @cascadence_position += 1
      end
    end

    def _debug_helper
      Cascadence.say "Current _debug_helper: #{@debug_counter}"
      @debug_counter ||= 0
      @debug_counter += 1
      throw "Recursion Limit Reached! cascadence_position: #{cascadence_position} --> #{next_step_name}" if 100 < @debug_counter
    end
  end

end