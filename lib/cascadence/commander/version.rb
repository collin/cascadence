module Cascadence
  class Commander
    class Version
      include Singleton

      def run
        File.read File.expand_path("../../../../VERSION", __FILE__)
      end
    end
  end
end