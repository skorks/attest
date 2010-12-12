require 'attest/expectation_result'

module Attest
  class ExecutionContext
    attr_reader :results

    class << self
      def assertions
        self.instance_methods(false).select{|method_name| method_name =~ /^should.*/ }.inspect
      end
    end

    def initialize
      @results = []
      @subject = self
    end

    def should_raise(type=nil, &block)
      result = Attest::ExpectationResult.new
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
      result.source_location = source_location
      @results << result
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
      result = Attest::ExpectationResult.new
      result.failure
      result.source_location = source_location
      @results << result
      self
    end

    def should_be_true(&block)
      result = Attest::ExpectationResult.new
      block_return = yield
      block_return ? result.success : result.failure
      result.source_location = source_location
      @results << result
      self
    end

    def should_not_raise(&block)
      should_raise(&block)
      result = @results.last
      result.success? ? result.failure : result.success
      result.source_location = source_location
      self
    end

    def should_not_be_true(&block)
      should_be_true(&block)
      result = @results.last
      result.success? ? result.failure : result.success
      result.source_location = source_location
      self
    end

    #worker methods
    def create_and_include(module_class)
      class_name = "#{module_class}Class"
      class_instance = Class.new
      Object.const_set class_name, class_instance
      Object.const_get(class_name).include(Object.const_get("#{module_class}"))
      klass = Object.const_get(class_name)
      klass.new
    end

    private 
    def source_location
      caller[1][/(.*:\d+):.*/, 1]
    end
  end
end
