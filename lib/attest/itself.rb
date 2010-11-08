module Attest
  class Itself
    def initialize(object)
      @itself = object
    end

    def should_equal(another_object)
      @itself == another_object
    end

    def should_not_equal(another_object)
      @itself != another_object
    end
  end
end
