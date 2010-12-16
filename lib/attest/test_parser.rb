require 'attest/test_container'
require 'attest/execution_context'
require 'attest/test_object'
require 'attest/core_ext/proc'

module Attest
  class TestParser
    def initialize(description, block)
      @description = description
      @block = block
      @before = nil
      @after = nil
      @tests = {}
      @nosetup_tests = {}
      @disabled_tests = {}
      @freestyle_tests = []
    end

    def parse
      self.instance_eval(&@block)
      test_container = Attest::TestContainer.new(@description)
      build_test_objects_and_add_to_container test_container
      build_freestyle_test_objects_and_add_to test_container
      test_container
    end

    def before_each(&block)
      @before = block 
    end

    def after_each(&block)
      @after = block
    end

    def test(description, &block)
      if @next_test_without_setup
        @nosetup_tests[description] = true
      end
      if @next_test_disabled
        @disabled_tests[description] = true
      end
      @tests[description] = block
      @next_test_without_setup = false
      @next_test_disabled = false
    end

    def nosetup
      @next_test_without_setup = true
    end

    def disabled
      @next_test_disabled = true
    end

    def method_missing(name, *args, &block)
      unless Attest::ExecutionContext.assertions.include? name
        super
      end
      @freestyle_tests << {:method_name => name, :args => args, :block => block}
    end

    private
    def build_test_objects_and_add_to_container(test_container)
      @tests.each_pair do |description, test_block|
        test_object = TestObject.new(description, test_block)
        test_object.nosetup = true if @nosetup_tests[description]
        test_object.disabled = true if @disabled_tests[description]
        test_object.add_setup(@before)
        test_object.add_cleanup(@after)
        test_container.add(test_object)
      end
    end

    def build_freestyle_test_objects_and_add_to(test_container)
      @freestyle_tests.each_with_index do |assertion_info, index|
        test_block = lambda {send(assertion_info[:method_name], *assertion_info[:args], &assertion_info[:block])}
        block_code = assertion_info[:block].to_string.collect{|line| line.strip}
        test_object = TestObject.new("freestyle test #{index + 1} - #{block_code.join(' ')}", test_block)
        test_object.nosetup = false
        test_container.add(test_object)
      end
    end
  end
end
