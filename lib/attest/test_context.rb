module Attest
  class TestContext
    include Dsl
    def initialize(description, block)
      @description = description
      @block = block
    end

    def execute
      self.instance_eval(&@block)
      puts @description
      @tests.each_pair do |key, value|
        @before.call if @before
        result = value.call
        puts " - #{key} #{'FAIL' if !result}"
        @after.call if @after
      end
    end
  end
end
