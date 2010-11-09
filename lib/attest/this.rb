module Attest
  class This
    def self.will_test(description="anonymous", &block)
      container = Attest::TestParser.new(description, block).parse
      container.execute_all
    end
  end
end

This = Attest::This

# parser should create a bunch of TestObject objects with all the befores and afters and the actual test itself
# parser should return a TestContainer object with a bunch of TestObject objects in it
