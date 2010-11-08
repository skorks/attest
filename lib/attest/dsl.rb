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
end
