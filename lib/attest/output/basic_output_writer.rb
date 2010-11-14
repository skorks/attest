module Attest
  module Output
    class BasicOutputWriter
      def initialize
        @containers = []
      end

      def before_everything
      end

      def before_context(container)
        @containers << container
        puts container.description
      end

      def before_test(test_object)
        print " - #{test_object.description}"
      end

      def after_test(test_object)
        relevant_result = nil
        test_object.results.each do |result|
          relevant_result = result if !result.success?
        end
        print " [#{relevant_result.status.upcase}]" if relevant_result
        if relevant_result && relevant_result.error?
          e = relevant_result.attributes[:unexpected_error]
          2.times { puts } 
          puts "    #{e.class}: #{e.message}"
          e.backtrace.each do |line|
            break if line =~ /lib\/attest/
              puts "    #{line} "
          end
        end
        puts
      end

      def after_context
      end

      def after_everything
      end
    end
  end
end
