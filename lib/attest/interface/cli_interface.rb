module Attest
  class CliInterface
    def initialize(opts={})
      @opts = opts
    end

    def configure
      require_relevant
      Attest.configure do |config|
        config.output_writer = Attest::Output::BasicOutputWriter.new
        config.testdouble = @opts[:testdouble]
      end
      configure_test_double
    end

    def configure_test_double
      if Attest.config.testdouble == "mocha"
        Bundler.setup(:development)
        require "mocha_standalone"
        Attest::ExecutionContext.include(Mocha::API) # need this so that methods like stub() and mock() can be accessed directly from the execution context
      end
    end

    def load_tests 
      switch_on_attest_mode
      Attest::TestLoader.load_tests_from(@opts[:file], @opts[:directory])
      Attest.output_writer.summary
      switch_off_attest_mode
    end

    def require_relevant
      require File.expand_path(File.dirname(__FILE__) + "/../../attest")
    end

    def switch_on_attest_mode
      ENV["attest"] = "true"
    end

    def switch_off_attest_mode
      ENV["attest"] = nil
    end
  end
end
