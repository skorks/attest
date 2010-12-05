module Attest
  class TestDoubleConfigurator 
    class << self
      def configure(test_double_identifier)
        test_double_identifier = test_double_identifier || default_test_double_identifier 
        raise "You have specified an unsupported test double framework" unless test_double_identifiers.include? test_double_identifier
        Attest.config.testdouble = test_double_identifier
        self.send(:"configure_#{test_double_identifier}")
      end

      def configure_mocha
        #Bundler.setup(:development) #TODO this may need to be something other than development, also may fail if project is not using bundler for whatever reason
        begin
        require "mocha_standalone"
        rescue LoadError => e
          puts "Trying to use mocha for test double functionality, but can't find it!"
          exit
        end
        Attest::ExecutionContext.include(Mocha::API) # need this so that methods like stub() and mock() can be accessed directly from the execution context
      end

      def default_test_double_identifier
        "mocha"
      end

      def test_double_identifiers
        [default_test_double_identifier]
      end
    end
  end
end
