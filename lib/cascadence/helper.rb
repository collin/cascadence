module Cascadence
  module Helper
    # see the specs for what these guys do
    def self.generate_tributary( arrays, starts=[], finish=[] )

      if starts.empty? || arrays.count == 1
        return arrays.reverse.flatten
      end
      generate_tributary arrays.push(replace_in_part(arrays.pop, arrays.pop, starts.pop, finish.pop) ), starts, finish
    end

    def self.replace_in_part(original, chunk, start, finish=nil)
      return chunk if original.nil? || original.empty?
      throw :OutOfRange if start >= original.count
      result = original.clone
      result[start..(finish||-1)] = chunk
      return result
    end

    def self.collect_superclasses(base, classes=[])
      return classes if base.nil?
      collect_superclasses(base.superclass, classes.unshift(base))
    end

  end
end