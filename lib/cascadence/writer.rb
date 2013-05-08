module Cascadence
  class Writer
    include Singleton
    attr_accessor :verbose_mode
    def say(text)
      puts text if verbose?
    end

    def verbose?
      @verbose_mode ||= false
    end

  end
end
