require 'attest'
require 'attest/execution_context'
require 'attest/expectation_result'

module Attest
  class TestObject
    attr_reader :description, :results
    attr_accessor :nosetup, :disabled, :before, :after
    def initialize(description, test_block)
      @description = description
      @test_block = test_block
      @results = []
    end

    def run(persistent_context)
      Attest.output_writer.before_test(self)
      error = nil
      context = Attest::ExecutionContext.new(persistent_context)
      begin
       #Object.class_eval do
         #define_method :itself do
           #subject = self
           #context.instance_eval {@subject = subject}
           #context
         #end
       #end
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
      create_and_add_result(:unexpected_error => error) {|result| result.error}
    end

    def add_pending_result
      create_and_add_result{|result| result.pending}
    end

    def add_disabled_result
      create_and_add_result{|result| result.disabled}
    end

    def add_success_result
      create_and_add_result{|result| result.success}
    end

    def create_and_add_result(opts={})
      result = Attest::ExpectationResult.new(opts)
      yield result
      @results << result
    end
  end
end
