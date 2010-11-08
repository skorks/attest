module Attest
  class Itself
    def initialize(object)
      @itself = object
    end

    def should
      @itself 
    end
  end
end
