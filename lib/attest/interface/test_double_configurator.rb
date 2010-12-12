require 'attest/execution_context'

module Attest
  class TestDoubleConfigurator 
    class << self
      def configure(test_double_identifier)
        test_double_identifier = test_double_identifier || default_test_double_identifier 
        raise "You have specified an unsupported test double framework" unless test_double_identifiers.include? test_double_identifier
        self.send(:"configure_#{test_double_identifier}")
        #Attest.config.testdouble = test_double_identifier
        test_double_identifier
      end

      def configure_mocha
        begin
          #how would this work when bundler is in play
          require "mocha_standalone"
        rescue LoadError => e
          puts "Trying to use mocha for test double functionality, but can't find it!"
          puts "Perhaps you forgot to install the mocha gem."
          exit
        end
        Attest::ExecutionContext.class_eval do
          include Mocha::API # need this so that methods like stub() and mock() can be accessed directly from the execution context
        end
      end

      def configure_none
      end

      def default_test_double_identifier
        "mocha"
      end

      def test_double_identifiers
        [default_test_double_identifier, "none"]
      end
    end
  end
end
