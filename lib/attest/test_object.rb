module Attest
  class TestObject
    def initialize(description, test_block)
      @description = description
      @test_block = test_block
      @before = nil
      @after = nil
    end

    def add_setup(block)
      @before = block
    end

    def add_cleanup(block)
      @after = block
    end

    def run
      error = nil
      begin
        context = Attest::ExecutionContext.new
        context.instance_eval(&@before) if @before
        result = context.instance_eval(&@test_block)
        context.instance_eval(&@after) if @after
        extra_output = ""
        extra_output = "FAIL" if !result
      rescue => e
        extra_output = "ERROR"
        error = e
      end
      puts " - #{description} #{extra_output}"
      puts "     #{e}" if error
    end
  end
end
