module Attest
  class CliInterface
    def initialize(opts={})
      @opts = opts
    end

    def configure
      #require_relevant
      OutputWriterConfigurator.configure(@opts[:outputwriter])
      TestDoubleConfigurator.configure(@opts[:testdouble])
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

    #def switch_on_attest_mode
      #ENV["attest"] = "true"
    #end

    #def switch_off_attest_mode
      #ENV["attest"] = nil
    #end
  end
end
