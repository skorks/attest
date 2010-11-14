module Attest
  class ExecutionContext
    attr_reader :results

    def initialize
      @results = []
      @subject = self
    end

    def should_raise(type=nil, &block)
      @results << Attest::ExpectationResult.new
      result = @results.last
      begin
        if block_given?
          yield
        end
      rescue => e
        result.update(:expected_error => e)
        if type && type == e.class
          result.success
        else
          result.success
        end
      end
      unless result.success?
        result.failure 
      end
      self
    end

    def with_message(regex)
      result = @results.last
      if result.success? && result.attributes[:expected_error]
        if !(result.attributes[:expected_error].message =~ regex)
          result.failure
        end
      end
      self
    end

    def should_fail
      @results << Attest::ExpectationResult.new
      result = @results.last
      result.failure
      self
    end

    def should_be_true(&block)
      @results << Attest::ExpectationResult.new
      result = @results.last
      block_return = yield
      block_return ? result.success : result.failure
      self
    end

    def should_not_raise(&block)
      should_raise(&block)
      result = @results.last
      result.success? ? result.failure : result.success
      self
    end

    def should_not_be_true(&block)
      should_be_true(&block)
      result = @results.last
      result.success? ? result.failure : result.success
      self
    end
  end
end
