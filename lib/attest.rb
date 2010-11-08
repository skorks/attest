require "rubygems"
require "bundler"
Bundler.setup(:default)
Bundler.require

module Attest
  module Dsl
    def before_all(&block)
      @before = block
    end

    def after_all(&block)
      @after = block
    end

    def test(description, &block)
      @tests = {} if !@tests
      @tests[description] = block
    end
  end

  class Itself
    def initialize(object)
      @itself = object
    end

    def should
     @itself 
    end
  end

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

module Kernel
  private
  def this_tests(subject, &block)
    test_context = Attest::TestContext.new(subject, block)
    test_context.execute
  end
end

class Object
  def itself 
    Attest::Itself.new(self)
  end
end
