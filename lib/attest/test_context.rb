module Attest
  class TestContext
    include Dsl
    def initialize(description, block)
      @description = description
      @block = block
    end

    def execute
      evaluate
      puts @description
      @tests.each_pair do |key, value|
        @before.call if @before
        run_test key, value
        @after.call if @after
      end
    end

    def evaluate
      self.instance_eval(&@block)
    end

    def run_test(test_description, test_block)
      output = "" 
      result = true
      begin
        result = test_block.call
        output = "FAIL" if !result
      rescue
        output = "ERROR"
      end
      puts " - #{test_description} #{output}"
    end
  end
end
