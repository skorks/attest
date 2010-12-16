require 'attest'
require 'attest/execution_context'
require 'attest/expectation_result'

module Attest
  class TestObject
    attr_reader :description, :results
    attr_accessor :nosetup, :disabled
    def initialize(description, test_block)
      @description = description
      @test_block = test_block
      @before = nil
      @after = nil
      @results = nil
    end

    def add_setup(block)
      @before = block
    end

    def add_cleanup(block)
      @after = block
    end

    def run
      Attest.output_writer.before_test(self)
      error = nil
      context = Attest::ExecutionContext.new
      begin
       Object.class_eval do
         define_method :itself do
           subject = self
           context.instance_eval {@subject = subject}
           context
         end
       end
       context.instance_eval(&@before) if @before && !nosetup && !disabled
       context.instance_eval(&@test_block) if @test_block && !disabled
       context.instance_eval(&@after) if @after && !nosetup && !disabled
      rescue => e
        error = e
      ensure
        @results = context.results
        add_unexpected_error_result(error) if error
        add_pending_result unless @test_block
        add_disabled_result if disabled
        add_success_result if @results.size == 0
      end
      Attest.output_writer.after_test(self)
    end

    private
    def add_unexpected_error_result(error)
      result = Attest::ExpectationResult.new(:unexpected_error => error)
      result.error
      @results << result
    end

    def add_pending_result
      result = Attest::ExpectationResult.new
      result.pending
      @results << result
    end

    def add_disabled_result
      result = Attest::ExpectationResult.new
      result.disabled
      @results << result
    end

    def add_success_result
      result = Attest::ExpectationResult.new
      result.success
      @results << result
    end
  end
end
