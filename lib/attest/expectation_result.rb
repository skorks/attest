module Attest
  class ExpectationResult
    def initialize(attributes={})
      @outcome = nil
      @attributes = attributes
    end

    def success
      @outcome = current_method
    end

    def failure
      @outcome = current_method
    end

    def error
      @outcome = current_method
    end
    
    def success?
      current_method.chop == @outcome
    end

    def error?
      current_method.chop == @outcome
    end

    def failure?
      current_method.chop == @outcome
    end

    def status
      @outcome
    end

    def update(attributes={})
      @attributes.merge!(attributes)
    end
  end
end
