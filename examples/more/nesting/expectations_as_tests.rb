class AssertionsAsTests
  class << self
    def five
      5
    end

    def error
      raise
    end
  end
end

if ENV["attest"]
  this_tests "the fact that assertions can be specified as tests" do
    should_be_true{5 == AssertionsAsTests.five}
    should_raise do 
      AssertionsAsTests.error
    end
  end
end
