module Attest
  class ExpectationResult
    def initialize
    end

    def success
    end

    def failure
    end

    def error
    end
    
    def success?
      if current_method.chop == @outcome
        true
      else
        false
      end
    end
  end
end
