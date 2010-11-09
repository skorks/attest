module Attest
  class ExecutionContext
    def should_not_raise
      begin
        if block_given?
          yield
        end
      rescue => e
        return false
      end
      true
    end

    def should_raise(&block)
      !should_not_raise(&block)
    end
  end
end
