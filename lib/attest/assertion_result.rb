module Attest
  class AssertionResult
    attr_accessor :context, :actual_error_object, :expected_error, :expected_error_message, :expected, :actual
    def initialize
      @context = nil
      @outcome = nil
      @actual_error_object = nil
      @expected_error = nil
      @expected_error_message = nil
      @expected = nil
      @actual = nil
    end

    def success
      @outcome = current_method
    end

    def failure
      @outcome = current_method
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
