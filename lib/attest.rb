require "rubygems"
require "bundler"
Bundler.setup(:default)
Bundler.require

module Attest

end

module Kernel
  private
  def this_tests(subject, &block)
    puts "this test"
    execution_environment = ExecutionEnvironment.new(block)
    execution_environment.evaluate
    execution_environment.execute
  end
end

class ExecutionEnvironment
  def initialize(test_definitions_block)
    @test_definitions_block = test_definitions_block
    @before = nil
    @after = nil
    @tests = {}
  end

  def evaluate
    self.instance_eval(&@test_definitions_block)
  end

  def execute
    @tests.each_pair do |key, value|
      puts key
    end
  end

  def before_all(&block)
    puts "before all"
    @before = block
  end

  def after_all(&block)
    puts "after all"
    @after = block
  end

  def test(description, &block)
    puts "test"
    @tests[description] = block
  end
end
