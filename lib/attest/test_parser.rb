module Attest
  class TestParser
    def initialize(description, block)
      @description = description
      @block = block
      @before = nil
      @after = nil
      @tests = {}
    end

    def parse
      self.instance_eval(&@block)
      test_container = Attest::TestContainer.new(@description)
      @tests.each_pair do |description, test_block|
        test_object = TestObject.new(description, test_block)
        test_object.add_setup(@before)
        test_object.add_cleanup(@after)
        test_container.add(test_object)
      end
      test_container
    end

    def before_all(&block)
      @before = block 
    end

    def after_all(&block)
      @after = block
    end

    def test(description, &block)
      @tests[description] = block
    end
  end
end
