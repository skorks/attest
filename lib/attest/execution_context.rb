require 'attest/expectation_result'

module Attest
  class ExecutionContext
    attr_reader :results

    class << self
      def assertions
        self.instance_methods(false).select{|method_name| method_name =~ /^should.*/ }.inspect
      end
    end

    def initialize(context=nil)
      @results = []
      @subject = self
      @persistent_context = context
      own_instance_variables = self.instance_variables
      context.instance_variables.each do |instance_variable|
        unless own_instance_variables.include? instance_variable
          self.instance_variable_set(instance_variable.to_s, context.instance_variable_get(instance_variable))
        end
      end
    end

    def should_be_true(&block)
      with_new_result do |result|
        block_return = yield
        block_return ? result.success : result.failure
      end
    end

    def should_not_be_true(&block)
      should_be_true(&block)
      with_last_result do |result|
        result.success? ? result.failure : result.success
      end
    end
    alias :should_be_false :should_not_be_true

    def should_fail
      with_new_result do |result|
        result.failure
      end
    end
    alias :should_not_succeed :should_fail

    def should_not_raise(&block)
      should_raise(&block)
      with_last_result do |result|
        result.success? ? result.failure : result.success
      end
    end

    #the only opt so far is :with_message which takes a regex
    def should_raise(type=nil, opts={}, &block)
      with_new_result do |result|
        begin
          if block_given?
            yield
          end
        rescue => e
          result.update(:expected_error => e)
          if expected_error?(type, opts[:with_message], e)
            result.success
          else
            result.failure
          end
        end
        unless result.success?
          result.failure 
        end
      end
    end

    #worker methods
    def create_and_include(module_class)
      class_name = "#{module_class}Class"
      klass = nil
      begin
        klass = Object.const_get(class_name)
      rescue NameError => e
        class_instance = Class.new
        Object.const_set class_name, class_instance
        Object.const_get(class_name).include(Object.const_get("#{module_class}"))
        klass = Object.const_get(class_name)
      end
      klass.new
    end

    private 
    def source_location
      caller[1][/(.*:\d+):.*/, 1]
    end

    def with_new_result
      result = Attest::ExpectationResult.new
      yield result
      result.source_location = source_location
      @results << result
    end

    def with_last_result
      result = @results.last
      yield result
      result.source_location = source_location
    end

    def expected_error?(expected_type, expected_message_regex, actual_error)
      if expected_type.nil? && expected_message_regex.nil? || expected_error_type?(expected_type, actual_error.class) && expected_message_regex.nil? || expected_error_type?(expected_type, actual_error.class) && error_message_matches?(expected_message_regex, actual_error.message)
        return true
      else
        return false
      end
    end

    def expected_error_type?(expected_type, actual_type)
      expected_type == actual_type
    end

    def error_message_matches?(expected_message_regex, actual_error_message)
      actual_error_message =~ expected_message_regex
    end
  end
end
