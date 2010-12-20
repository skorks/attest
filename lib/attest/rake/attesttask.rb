require 'rake'
require 'rake/tasklib'

module Rake 
  class AttestTask < TaskLib
    attr_accessor :include, :exclude, :outputwriter, :testdouble
    def initialize
      @include = "attest/"
      @exclude = nil
      @outputwriter = "Basic"
      @testdouble = "mocha"
      yield self if block_given?
      define
    end

    def define
      desc "Run attest tests"
      task :attest do
        $:.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../../../lib/'))) unless $:.include?(File.expand_path(File.join(File.dirname(__FILE__), '../../../lib')))
        require 'attest'
        require 'attest/interface/output_writer_configurator'
        require 'attest/interface/test_double_configurator'
        require 'attest/interface/possible_tests_configurator'

        Attest.configure do |config|
          config.output_writer = Attest::OutputWriterConfigurator.configure(@outputwriter)
          config.testdouble = Attest::TestDoubleConfigurator.configure(@testdouble)
          config.possible_tests = Attest::PossibleTestsConfigurator.configure(@include, @exclude)
        end

        require 'attest/test_loader'

        Attest::TestLoader.execute(Attest.config.possible_tests, Attest.config.output_writer)
      end
      self
    end
  end
end
