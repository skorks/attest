require 'attest/output/output_writer'
require 'attest/expectation_result'

module Attest
  module Output
    class TestUnitOutputWriter < Attest::Output::OutputWriter
      def before_all_tests
        super
        puts 
      end

      def after_all_tests
        super
        puts 
      end

      def before_container(container)
        previous_container = @containers.last
        @containers << container
      end

      def after_test(test_object)
        relevant_result = determine_relevant_result test_object
        if relevant_result
          print "#{relevant_result.status.upcase[0]}"
        else
          print '.'
        end
      end
    end
  end
end
