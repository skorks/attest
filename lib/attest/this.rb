module Attest
  class This
    def self.will_test(description="anonymous", &block)
      container = Attest::TestParser.new(description, block).parse
      container.execute_all
    end
  end
end

This = Attest::This
